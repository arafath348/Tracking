//
//  Localization.swift
//  3M Asset Tracking
//
//  Created by wipro on 08/11/17.
//  Copyright © 2017 IndianRenters. All rights reserved.
//

import Foundation

class Localization {

    fileprivate static var languageCache: String?
    fileprivate static var languageBundle: Bundle?

    class func create() {
       
        method_exchangeImplementations(
            class_getInstanceMethod(
                Bundle.self,
                #selector(Bundle.localizedString(forKey:value:table:))
            ),
            class_getInstanceMethod(
                Bundle.self,
                #selector(Bundle.specialLocalizedString(forKey:value:table:))
            )
        )
    }


}


extension Bundle {

    func specialLocalizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        
        var selectedLang:String
        let database = DatabaseHandler()
        
        selectedLang = database.getLanguageSettings().object(at: 0) as! String
        
        if Localization.languageCache != selectedLang || Localization.languageBundle == nil//It is called only when language is changed or on fresh load which is = nil
        {

           Localization.languageCache = selectedLang

            
        var path: String

            if (selectedLang == "German"){
                path = Bundle.main.path(forResource: "de", ofType: "lproj")!
                Localization.languageBundle = Bundle(path: path)

                
            }
            if (selectedLang == "Spanish"){
                path = Bundle.main.path(forResource: "es", ofType: "lproj")!
                Localization.languageBundle = Bundle(path: path)

            }
        if (selectedLang == "France French"){
            path = Bundle.main.path(forResource: "es", ofType: "lproj")!
            Localization.languageBundle = Bundle(path: path)
            
        }
        if (selectedLang == "French Canadian"){
            path = Bundle.main.path(forResource: "es", ofType: "lproj")!
            Localization.languageBundle = Bundle(path: path)
            
        }
        if (selectedLang == "English"){
            path = Bundle.main.path(forResource: "en-001", ofType: "lproj")!
            Localization.languageBundle = Bundle(path: path)
            
        }
            if (selectedLang == "en"){
                path = Bundle.main.path(forResource: "en-001", ofType: "lproj")!
                Localization.languageBundle = Bundle(path: path)
        }
        

      }

        return Localization.languageBundle!.specialLocalizedString(
            forKey: key, value: value, table: tableName
        )
    }
  

}

