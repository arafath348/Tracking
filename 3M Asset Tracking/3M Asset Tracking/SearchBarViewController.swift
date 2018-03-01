//
//  SearchBarViewController.swift
//  3M L&M
//
//  Created by IndianRenters on 31/07/17.
//  Copyright © 2017 3M L&M. All rights reserved.
//

import UIKit

protocol SearchBarDelegate: class {
    func selectedValue(company: String,utilityCompanyId: String,titleString: String)
}



class SearchBarViewController: UIViewController {
    
    @IBOutlet weak var table: UITableView!
    weak var delegate: SearchBarDelegate?
    var companyArray: NSArray!
    var utilityCompanyIdArray: NSArray!
    var fromScreen: String = ""
    var titleString: String = ""
    var needAddButton: Bool = false


    
  
    var searchArray = [String]() {
        didSet {
            NotificationCenter.default.post(name: NSNotification.Name.init("searchResultsUpdated"), object: searchArray)
        }
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
//        self.navigationItem.setHidesBackButton(true, animated:false)
    }
    override func viewWillDisappear(_ animated: Bool) {
//        self.navigationItem.setHidesBackButton(false, animated:false)
        self.countrySearchController.isActive = false
    }
    
    
    
    
    
    
    var countrySearchController: UISearchController = ({
        /* Display search results in a separate view controller */
        let storyBoard = UIStoryboard(name: "Custom", bundle: Bundle.main)
        let controller = UISearchController(searchResultsController: nil)
        controller.hidesNavigationBarDuringPresentation = false
        controller.dimsBackgroundDuringPresentation = false
        controller.searchBar.searchBarStyle = .minimal
        controller.searchBar.sizeToFit()
        controller.searchBar.placeholder = NSLocalizedString("Search", comment: "")
        controller.searchBar.backgroundColor = UIColor .white
        return controller
    })()
    
    func addCompany(){
        
       countrySearchController.isActive = false

        var alert = UIAlertController()
        
        if (titleString == "Select Company"){
        
         alert = UIAlertController(title: "Add Company?", message: "Are you sure you want to add a new company?", preferredStyle: UIAlertControllerStyle.alert)
        
        }
        else if (titleString == "Select Installer Company"){
            alert = UIAlertController(title: "Add Installer Company?", message: "Are you sure you want to add a new installer company?", preferredStyle: UIAlertControllerStyle.alert)
        }
        else if (titleString == "Select Project"){
            alert = UIAlertController(title: "Add Project?", message: "Are you sure you want to add a new project?", preferredStyle: UIAlertControllerStyle.alert)
        }
        
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("YES", comment: "YES"), style: .default, handler: { (action: UIAlertAction!) in
            self.navigationController?.popViewController(animated: true)
            self.delegate?.selectedValue(company: "", utilityCompanyId: "", titleString: self.titleString)
            
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("NO", comment: "NO"), style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        present(alert, animated: true, completion: nil)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        if (needAddButton == true){
            let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCompany))
            navigationItem.rightBarButtonItems = [add]
        }
        
        self.title = titleString
           
        table.tableHeaderView = countrySearchController.searchBar
        
        countrySearchController.searchResultsUpdater = self
        

        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension SearchBarViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        switch countrySearchController.isActive {
        case true:
            return searchArray.count
        case false:
            return companyArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = table.dequeueReusableCell(withIdentifier: "Cell") as! SearchTableViewCell
        cell.textLabel?.text = ""
        cell.textLabel?.attributedText = NSAttributedString(string: "")
       
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        
        switch (deviceIdiom) {
            
        case .pad:
            cell.textLabel?.font = UIFont(name: "3MCircularTT-Book", size: 18)
        case .phone:
            cell.textLabel?.font = UIFont(name: "3MCircularTT-Book", size: 14)
        default:
            cell.textLabel?.font = UIFont(name: "3MCircularTT-Book", size: 14)
        }
        
        
        
        
        
        
        
        
        switch countrySearchController.isActive {
        case true:
            cell.configureCell(with: countrySearchController.searchBar.text!, cellText: searchArray[indexPath.row])
            return cell
        case false:
            cell.textLabel?.text! = companyArray.object(at: indexPath.row) as! String
            return cell
        }
    }
}

extension SearchBarViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
   
         switch countrySearchController.isActive {
        case true:
            let index:Int = companyArray.index(of: searchArray[indexPath.row])
            delegate?.selectedValue(company: searchArray[indexPath.row], utilityCompanyId: utilityCompanyIdArray.object(at: index) as! String, titleString: titleString)

    
        case false:
           delegate?.selectedValue(company: companyArray.object(at: indexPath.row) as! String, utilityCompanyId: utilityCompanyIdArray.object(at: indexPath.row) as! String, titleString: titleString)
        }
        
        self.navigationController?.popViewController(animated: true)
            countrySearchController.isActive = false

        }
        

}

extension SearchBarViewController: UISearchResultsUpdating
{
    func updateSearchResults(for searchController: UISearchController)
    {
        if searchController.searchBar.text?.utf8.count == 0 {
            searchArray = companyArray as! [String]
            table.reloadData()
        } else {
            searchArray.removeAll(keepingCapacity: false)
            
            let range = searchController.searchBar.text!.characters.startIndex ..< searchController.searchBar.text!.characters.endIndex
            var searchString = String()
            
            searchController.searchBar.text?.enumerateSubstrings(in: range, options: .byComposedCharacterSequences, { (substring, substringRange, enclosingRange, success) in
                searchString.append(substring!)
                searchString.append("*")
            })
            
            let searchPredicate = NSPredicate(format: "SELF LIKE[cd] %@", searchString)
            let array = (companyArray).filtered(using: searchPredicate)
            searchArray = array as! [String]
            table.reloadData()
        }
    }
}
