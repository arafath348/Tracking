//
//  LanguageSettingsViewController.swift
//  3M L&M
//
//  Created by IndianRenters on 25/07/17.
//  Copyright © 2017 3M L&M. All rights reserved.
//

import UIKit

class LanguageSettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PopupDelegate {
    var row: Int = 0
    @IBOutlet weak var table: UITableView?
    var languageSettingsArray: NSArray = []
    let database = DatabaseHandler()
    var languageArray: NSArray = []
    var selectedLanguageArray: NSMutableArray = []
    
    var titleStringApp: NSString = ""
    var titleStringGlossary: NSString = ""
    
    // var appSelectedLanguage: NSString = ""
    
    struct AppLanguage {
        static var appSelectedLanguage = ""
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        changeLanguage()
        // Do any additional setup after loading the view.
        
        
        languageSettingsArray = [NSLocalizedString("Application", comment: "Application"),NSLocalizedString("Template glossary", comment: "Template glossary")]
        
        
        selectedLanguageArray = database.getLanguageSettings() as! NSMutableArray
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //TealiumHelper.trackView(NSStringFromClass(self.classForCoder), dataSources: [:])
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Localization.create()
        
        changeLanguage()
    }
    
    
    // MARK:  UITableView Data Source Methods
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat    {
        return 73
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languageSettingsArray.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell : CustomTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "CustomLanguageSettingsCell") as! CustomTableViewCell!)
        
        cell.titleLabel.text = languageSettingsArray .object(at: indexPath.row) as? String
        
        let string:String = selectedLanguageArray[indexPath.row]  as! String
        if !string.isEmpty {
            cell.subLabel.text = string
        }
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        row = indexPath.row
        let popOverVC = UIStoryboard(name: "Custom", bundle: nil).instantiateViewController(withIdentifier: "sbPopUpID") as! PopUpViewController
        
        self.addChildViewController(popOverVC)
        popOverVC.delegate = self
        
        
        
        if indexPath.row == 0 {
            languageArray = database .getLanguageArrayForApplication()
            popOverVC.titleString = titleStringApp as String//NSLocalizedString("Select Application Language", comment: "Select Application Language")
        }
        else
        {
            languageArray = database .getLanguageArrayForGlossary()
            popOverVC.titleString = titleStringGlossary as String//NSLocalizedString("Select Template Glossary", comment: "Select Template Glossary")
        }
        
        
        
        
        popOverVC.popupArray = languageArray .object(at: 1) as! NSArray
        
        print(popOverVC.popupArray)
        let string:String = selectedLanguageArray[indexPath.row]  as! String
        if !string.isEmpty {
            popOverVC.selectedString = string
        }
        
        popOverVC.view.frame = CGRect(x: 0, y: -64, width: self.view.frame.width, height: self.view.frame.height+64)
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        
        
    }
    
    
    func selectedValue(_ selectedString: String){
        selectedLanguageArray[row] = selectedString
        AppLanguage.appSelectedLanguage = selectedString
        
        if row == 0 {
            database.updateAppLanguageSetting(languageName: selectedString)
        }
        else
        {
            let languageId:String = database.getLanguageId(LanguageName: selectedString)
            database.updateGlossaryLangaugeSetting(languageId: languageId, languageName: selectedString)
        }
        
        changeLanguage()
        
        table? .reloadData()
        
    }
    
    func changeLanguage()
    {
        self.title = NSLocalizedString("Language Settings", comment: "langage")
        languageSettingsArray = [NSLocalizedString("Application", comment: "Application"),NSLocalizedString("Template glossary", comment: "Template glossary")]
        //Start
        titleStringApp = NSLocalizedString("Select Application Language", comment: "Select Application Language") as NSString
        titleStringGlossary = NSLocalizedString("Select Template Glossary", comment: "Select Template Glossary") as NSString
        
        
        titleStringApp = NSLocalizedString("Select Application Language", comment: "Select Application Language") as NSString
        titleStringGlossary = NSLocalizedString("Select Template Glossary", comment: "Select Template Glossary") as NSString
        languageSettingsArray = [NSLocalizedString("Application", comment: "Application"),NSLocalizedString("Template glossary", comment: "Template glossary")]
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}


