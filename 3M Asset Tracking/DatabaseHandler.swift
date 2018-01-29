
//  DatabaseHandler.swift
//  3M L&M
//
//  Created by IndianRenters on 03/08/17.
//  Copyright © 2017 3M L&M. All rights reserved.
//

import UIKit

class DatabaseHandler: NSObject {
    var databasePath = "databasePath"
    var mutableArray: NSMutableArray = []
    
    func connectDb()
    {
        let sourcePath = Bundle.main.path(forResource: "db", ofType: "sqlite")
        databasePath = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("db.sqlite").path
        do {
            try FileManager().copyItem(atPath: sourcePath!, toPath: databasePath)
            
        } catch _ {
        }
    }
    
    
    
    func deleteAllTable(){
        self .connectDb()
        
        //read it
        let contactDB = FMDatabase(path: databasePath as String)
        
        
        if !contactDB!.open() {
            print("Error: \(contactDB!.lastErrorMessage())")
        }
            
        else{
            
            let tableArray:NSArray = ["sqlite_sequence","tblDataCategory","tblDataType","tblDescriptionTranslation", "tblFunctionType","tblInstallerCompany","tblLabelTranslation","tblLabelVsDescXREF","tblLanguage","tblLogData", "tblLogDataDetail","tblPredefinedDescription","tblPredefinedLabel","tblProductCatalogue","tblProject","tblRecordType","tblSecurityQuestion","tblSmartUser","tblTemplate","tblTemplateDetails","tblTemplateType","tblUserLog","tblUserProfile","tblUtilityCompany","tblUtilityCompanyAdmin","tblUtilityCompanyType","tblUtilityVsInstallerCompXREF"]
            
            
            for i in 0 ..< tableArray.count {
                let sqlStrDelete: String = String(format: "delete from '\(tableArray .object(at: i))'")
                if contactDB!.executeUpdate(sqlStrDelete, withArgumentsIn: nil)
                {
                    print("'\(tableArray .object(at: i))' deleted successfully")
                }
                else {
                    NSLog("'\(tableArray .object(at: i))' NOT deleted successfully, check again.")
                }
            }
            
        }
        
        
        print(databasePath)
    }
    
    
    //    func checkNullValue(stringValue: String) -> String {
    //        if let value = stringValue as? String{
    //            return value
    //        }
    //
    //     return ""
    //    }
    //
    
    
    
    
    func insertFunctionType(array: NSArray) {
        
        self .connectDb()
        
        //read it
        let contactDB = FMDatabase(path: databasePath as String)
        
        
        if !contactDB!.open() {
            print("Error: \(contactDB!.lastErrorMessage())")
        }
            
        else{
            
            
            for temp in array {
                
                
                var createdBy:String = ""
                var createdDate:Int = 0
                var functionTypeDesc:String = ""
                var functionTypeId:Int = 0
                var updatedBy:String = ""
                var updatedDate:Int = 0
                
                if let value = (temp as AnyObject).object(forKey: "createdBy") as? String{
                    createdBy = value
                }
                if let value = (temp as AnyObject).object(forKey: "createdDate") as? Int{
                    createdDate = value
                }
                if let value = (temp as AnyObject).object(forKey: "functionTypeDesc") as? String{
                    functionTypeDesc = value
                }
                if let value = (temp as AnyObject).object(forKey: "functionTypeId") as? Int{
                    functionTypeId = value
                }
                if let value = (temp as AnyObject).object(forKey: "updatedBy") as? String{
                    updatedBy = value
                }
                if let value = (temp as AnyObject).object(forKey: "updatedDate") as? Int{
                    updatedDate = value
                }
                
                
                let insertSQL = "INSERT or REPLACE INTO tblFunctionType (createdBy, createdDate, functionTypeDesc, functionTypeId, updatedBy, updatedDate) VALUES ('\(createdBy)', '\(createdDate)', '\(functionTypeDesc)', '\(functionTypeId)', '\(updatedBy)', '\(updatedDate)')"
                
                let result = contactDB!.executeUpdate(insertSQL, withArgumentsIn: nil)
                
                if !result {
                    print("Error: \(contactDB!.lastErrorMessage())")
                }
                
            }
            
        }
        
        
        print(databasePath)
    }
    
    
    
    func getLanguageArrayForApplication() -> NSMutableArray {
        
        self .connectDb()
        
        mutableArray = NSMutableArray()
        
        let contactDB = FMDatabase(path: databasePath as String)
        
        let languageIdArray = NSMutableArray()
        let languageNameArray = NSMutableArray()
        
        
        
        if (contactDB!.open()) {
            let querySQL = "SELECT * FROM tblLanguage where hasAppLanguageSupport = 'Y' order by LanguageName"
            
            let results:FMResultSet? = contactDB?.executeQuery(querySQL, withArgumentsIn: nil)
            
            
            while ((results?.next()) == true) {
                languageIdArray .add(results!.string(forColumn: "languageId"))
                languageNameArray .add(results!.string(forColumn: "LanguageName"))
            }
            contactDB?.close()
            
        } else {
            print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
        }
        
        mutableArray.add(languageIdArray)
        mutableArray.add(languageNameArray)
        
        
        print(databasePath)
        return mutableArray
        
    }
    
    func getLanguageArrayForGlossary() -> NSMutableArray {
        
        self .connectDb()
        
        mutableArray = NSMutableArray()
        
        let contactDB = FMDatabase(path: databasePath as String)
        
        let languageIdArray = NSMutableArray()
        let languageNameArray = NSMutableArray()
        
        
        if (contactDB!.open()) {
            let querySQL = "SELECT * FROM tblLanguage where hasGlossaryLanguageSupport = 'Y' order by LanguageName"
            
            let results:FMResultSet? = contactDB?.executeQuery(querySQL, withArgumentsIn: nil)
            
            
            while ((results?.next()) == true) {
                languageIdArray .add(results!.string(forColumn: "languageId"))
                languageNameArray .add(results!.string(forColumn: "LanguageName"))
            }
            contactDB?.close()
            
        } else {
            print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
        }
        
        mutableArray.add(languageIdArray)
        mutableArray.add(languageNameArray)
        
        
        print(databasePath)
        return mutableArray
        
    }
    
    
    func insertDataCategory(array: NSArray) {
        
        self .connectDb()
        
        //read it
        let contactDB = FMDatabase(path: databasePath as String)
        
        
        if !contactDB!.open() {
            print("Error: \(contactDB!.lastErrorMessage())")
        }
            
        else{
            
            
            
            
            for temp in array {
                
                var createdBy:String = ""
                var createdDate:Int = 0
                var dataCategoryDesc:String = ""
                var datacategoryId:Int = 0
                var updatedBy:String = ""
                var updatedDate:Int = 0
                
                if let value = (temp as AnyObject).object(forKey: "createdBy") as? String{
                    createdBy = value
                }
                if let value = (temp as AnyObject).object(forKey: "createdDate") as? Int{
                    createdDate = value
                }
                if let value = (temp as AnyObject).object(forKey: "dataCategoryDesc") as? String{
                    dataCategoryDesc = value
                }
                if let value = (temp as AnyObject).object(forKey: "datacategoryId") as? Int{
                    datacategoryId = value
                }
                if let value = (temp as AnyObject).object(forKey: "updatedBy") as? String{
                    updatedBy = value
                }
                if let value = (temp as AnyObject).object(forKey: "updatedDate") as? Int{
                    updatedDate = value
                }
                
                
                
                
                let insertSQL = "INSERT or REPLACE INTO tblDataCategory (createdBy, createdDate, dataCategoryDesc, datacategoryId, updatedBy, updatedDate) VALUES ('\(createdBy)', '\(createdDate)', '\(dataCategoryDesc)', '\(datacategoryId)', '\(updatedBy)', '\(updatedDate)')"
                
                let result = contactDB!.executeUpdate(insertSQL, withArgumentsIn: nil)
                
                if !result {
                    print("Error: \(contactDB!.lastErrorMessage())")
                }
                
            }
            
        }
        
        
    }
    
    
    
    
    func insertDataType(array: NSArray) {
        
        self .connectDb()
        
        //read it
        let contactDB = FMDatabase(path: databasePath as String)
        
        
        if !contactDB!.open() {
            print("Error: \(contactDB!.lastErrorMessage())")
        }
            
        else{
            
            
            
            
            for temp in array {
                
                var createdBy:String = ""
                var createdDate:Int = 0
                var dataType:String = ""
                var dataTypeId:Int = 0
                var isAvailableforUserDefLabels:String = ""
                var updatedBy:String = ""
                var updatedDate:Int = 0
                
                if let value = (temp as AnyObject).object(forKey: "createdBy") as? String{
                    createdBy = value
                }
                if let value = (temp as AnyObject).object(forKey: "createdDate") as? Int{
                    createdDate = value
                }
                if let value = (temp as AnyObject).object(forKey: "dataType") as? String{
                    dataType = value
                }
                if let value = (temp as AnyObject).object(forKey: "dataTypeId") as? Int{
                    dataTypeId = value
                }
                if let value = (temp as AnyObject).object(forKey: "isAvailableforUserDefLabels") as? String{
                    isAvailableforUserDefLabels = value
                }
                if let value = (temp as AnyObject).object(forKey: "updatedBy") as? String{
                    updatedBy = value
                }
                if let value = (temp as AnyObject).object(forKey: "updatedDate") as? Int{
                    updatedDate = value
                }
                
                
                
                
                let insertSQL = "INSERT or REPLACE INTO tblDataType (createdBy, createdDate, dataType, dataTypeId, isAvailableforUserDefLabels, updatedBy, updatedDate) VALUES ('\(createdBy)', '\(createdDate)', '\(dataType)', '\(dataTypeId)', '\(isAvailableforUserDefLabels)', '\(updatedBy)', '\(updatedDate)')"
                
                let result = contactDB!.executeUpdate(insertSQL, withArgumentsIn: nil)
                
                if !result {
                    print("Error: \(contactDB!.lastErrorMessage())")
                }
                
            }
            
        }
        
        
    }
    
    
    
    
    
    func insertDescriptionTranslation(array: NSArray) {
        
        self .connectDb()
        
        //read it
        let contactDB = FMDatabase(path: databasePath as String)
        
        
        if !contactDB!.open() {
            print("Error: \(contactDB!.lastErrorMessage())")
        }
            
        else{
            
            
            
            
            for temp in array {
                
                var languageDisplayName:String = ""
                var createdBy:String = ""
                var createdDate:Int = 0
                var languageId:Int = 0
                var predefinedDescriptionId:Int = 0
                var updatedBy:String = ""
                var updatedDate:Int = 0
                
                
                if let value = (temp as AnyObject).object(forKey: "languageDisplayName") as? String{
                    languageDisplayName = value
                }
                if let value = (temp as AnyObject).object(forKey: "createdBy") as? String{
                    createdBy = value
                }
                if let value = (temp as AnyObject).object(forKey: "createdDate") as? Int{
                    createdDate = value
                }
                if let value = (temp as AnyObject).object(forKey: "languageId") as? Int{
                    languageId = value
                }
                if let value = (temp as AnyObject).object(forKey: "predefinedDescriptionId") as? Int{
                    predefinedDescriptionId = value
                }
                if let value = (temp as AnyObject).object(forKey: "updatedBy") as? String{
                    updatedBy = value
                }
                if let value = (temp as AnyObject).object(forKey: "updatedDate") as? Int{
                    updatedDate = value
                }
                
                
                let insertSQL = "INSERT or REPLACE INTO tblDescriptionTranslation (createdBy, createdDate, languageDisplayName, languageId, predefinedDescriptionId, updatedBy, updatedDate) VALUES ('\(createdBy)', '\(createdDate)', '\(languageDisplayName)', '\(languageId)', '\(predefinedDescriptionId)', '\(updatedBy)', '\(updatedDate)')"
                
                let result = contactDB!.executeUpdate(insertSQL, withArgumentsIn: nil)
                
                if !result {
                    print("Error: \(contactDB!.lastErrorMessage())")
                }
                
            }
            
        }
        
        
    }
    
    
    
    
    func insertLabelTranslation(array: NSArray) {
        
        self .connectDb()
        
        //read it
        let contactDB = FMDatabase(path: databasePath as String)
        
        
        if !contactDB!.open() {
            print("Error: \(contactDB!.lastErrorMessage())")
        }
            
        else{
            
            
            
            
            for temp in array {
                
                var languageDisplayName:String = ""
                var createdBy:String = ""
                var createdDate:Int = 0
                var languageId:Int = 0
                var predefinedLabelId:Int = 0
                var updatedBy:String = ""
                var updatedDate:Int = 0
                
                
                if let value = (temp as AnyObject).object(forKey: "languageDisplayName") as? String{
                    languageDisplayName = value
                }
                if let value = (temp as AnyObject).object(forKey: "createdBy") as? String{
                    createdBy = value
                }
                if let value = (temp as AnyObject).object(forKey: "createdDate") as? Int{
                    createdDate = value
                }
                if let value = (temp as AnyObject).object(forKey: "languageId") as? Int{
                    languageId = value
                }
                if let value = (temp as AnyObject).object(forKey: "predefinedLabelId") as? Int{
                    predefinedLabelId = value
                }
                if let value = (temp as AnyObject).object(forKey: "updatedBy") as? String{
                    updatedBy = value
                }
                if let value = (temp as AnyObject).object(forKey: "updatedDate") as? Int{
                    updatedDate = value
                }
                
                
                
                
                let insertSQL = "INSERT or REPLACE INTO tblLabelTranslation(createdBy, createdDate, languageId, languageDisplayName,predefinedLabelId, updatedBy, updatedDate) VALUES ('\(createdBy)', '\(createdDate)', '\(languageId)', '\(languageDisplayName)','\(predefinedLabelId)', '\(updatedBy)', '\(updatedDate)')"
                
                let result = contactDB!.executeUpdate(insertSQL, withArgumentsIn: nil)
                
                if !result {
                    print("Error: \(contactDB!.lastErrorMessage())")
                }
                
            }
            
        }
        
    }
    
    
    func insertLabelVsDescXREF(array: NSArray) {
        
        self .connectDb()
        
        //read it
        let contactDB = FMDatabase(path: databasePath as String)
        
        
        if !contactDB!.open() {
            print("Error: \(contactDB!.lastErrorMessage())")
        }
            
        else{
            
            
            
            for temp in array {
                
                
                var createdBy:String = ""
                var createdDate:Int = 0
                var predefinedLabelId:Int = 0
                var predefinedDescriptionID:Int = 0
                var updatedBy:String = ""
                var updatedDate:Int = 0
                
                
                
                
                if let value = (temp as AnyObject).object(forKey: "createdBy") as? String{
                    createdBy = value
                }
                if let value = (temp as AnyObject).object(forKey: "createdDate") as? Int{
                    createdDate = value
                }
                if let value = (temp as AnyObject).object(forKey: "predefinedLabelId") as? Int{
                    predefinedLabelId = value
                }
                if let value = (temp as AnyObject).object(forKey: "predefinedDescriptionId") as? Int{
                    predefinedDescriptionID = value
                }
                if let value = (temp as AnyObject).object(forKey: "updatedBy") as? String{
                    updatedBy = value
                }
                if let value = (temp as AnyObject).object(forKey: "updatedDate") as? Int{
                    updatedDate = value
                }
                
                
                
                
                
                let insertSQL = "INSERT or REPLACE INTO tblLabelVsDescXREF(createdBy, createdDate, predefinedLabelId, predefinedDescriptionID, updatedBy, updatedDate) VALUES ('\(createdBy)', '\(createdDate)', '\(predefinedLabelId)', '\(predefinedDescriptionID)','\(updatedBy)', '\(updatedDate)')"
                
                
                
                
                
                let result = contactDB!.executeUpdate(insertSQL, withArgumentsIn: nil)
                
                if !result {
                    print("Error: \(contactDB!.lastErrorMessage())")
                }
                
            }
            
        }
        
        
        print(databasePath)
    }
    
    
    
    func insertLanguage(array: NSArray) {
        
        self .connectDb()
        
        //read it
        let contactDB = FMDatabase(path: databasePath as String)
        
        
        if !contactDB!.open() {
            print("Error: \(contactDB!.lastErrorMessage())")
        }
            
        else{
            
            
            
            
            for temp in array {
                
                
                var createdBy:String = ""
                var createdDate:Int = 0
                var hasAppLanguageSupport:String = ""
                var hasGlossaryLanguageSupport:String = ""
                var languageCode:String = ""
                var languageId:Int = 0
                var languageName:String = ""
                var updatedBy:String = ""
                var updatedDate:Int = 0
                
                
                
                
                if let value = (temp as AnyObject).object(forKey: "createdBy") as? String{
                    createdBy = value
                }
                if let value = (temp as AnyObject).object(forKey: "createdDate") as? Int{
                    createdDate = value
                }
                if let value = (temp as AnyObject).object(forKey: "hasAppLanguageSupport") as? String{
                    hasAppLanguageSupport = value
                }
                if let value = (temp as AnyObject).object(forKey: "hasGlossaryLanguageSupport") as? String{
                    hasGlossaryLanguageSupport = value
                }
                if let value = (temp as AnyObject).object(forKey: "hasAppLanguageSupport") as? String{
                    hasAppLanguageSupport = value
                }
                if let value = (temp as AnyObject).object(forKey: "languageCode") as? String{
                    languageCode = value
                }
                if let value = (temp as AnyObject).object(forKey: "languageId") as? Int{
                    languageId = value
                }
                if let value = (temp as AnyObject).object(forKey: "languageName") as? String{
                    languageName = value
                }
                if let value = (temp as AnyObject).object(forKey: "updatedBy") as? String{
                    updatedBy = value
                }
                if let value = (temp as AnyObject).object(forKey: "updatedDate") as? Int{
                    updatedDate = value
                }
                
                
                
                
                let insertSQL = "INSERT or REPLACE INTO tblLanguage (createdBy, createdDate, hasAppLanguageSupport, languageCode, languageId,languageName, updatedBy, updatedDate, hasGlossaryLanguageSupport) VALUES ('\(createdBy)', '\(createdDate)', '\(hasAppLanguageSupport)', '\(languageCode)','\(languageId)', '\(languageName)', '\(updatedBy)', '\(updatedDate)', '\(hasGlossaryLanguageSupport)')"
                
                let result = contactDB!.executeUpdate(insertSQL, withArgumentsIn: nil)
                
                if !result {
                    print("Error: \(contactDB!.lastErrorMessage())")
                }
                
            }
            
        }
        
        
    }
    
    
    
    
    
    
    func insertPredefinedDescription(array: NSArray) {
        
        self .connectDb()
        
        //read it
        let contactDB = FMDatabase(path: databasePath as String)
        
        
        if !contactDB!.open() {
            print("Error: \(contactDB!.lastErrorMessage())")
        }
            
        else{
            
            
            
            
            for temp in array {
                
                
                var createdBy:String = ""
                var createdDate:Int = 0
                var englishDisplayName:String = ""
                var fieldName:String = ""
                var predefinedDescriptionId:Int = 0
                var updatedBy:String = ""
                var updatedDate:Int = 0
                
                
                if let value = (temp as AnyObject).object(forKey: "createdBy") as? String{
                    createdBy = value
                }
                if let value = (temp as AnyObject).object(forKey: "createdDate") as? Int{
                    createdDate = value
                }
                if let value = (temp as AnyObject).object(forKey: "englishDisplayName") as? String{
                    englishDisplayName = value
                }
                if let value = (temp as AnyObject).object(forKey: "fieldName") as? String{
                    fieldName = value
                }
                if let value = (temp as AnyObject).object(forKey: "predefinedDescriptionId") as? Int{
                    predefinedDescriptionId = value
                }
                if let value = (temp as AnyObject).object(forKey: "updatedBy") as? String{
                    updatedBy = value
                }
                if let value = (temp as AnyObject).object(forKey: "updatedDate") as? Int{
                    updatedDate = value
                }
                
                
                
                
                let insertSQL = "INSERT or REPLACE INTO tblPredefinedDescription (createdBy, createdDate, englishDisplayName, fieldName, predefinedDescriptionId, updatedBy, updatedDate) VALUES ('\(createdBy)', '\(createdDate)', '\(englishDisplayName)', '\(fieldName)','\(predefinedDescriptionId)', '\(updatedBy)', '\(updatedDate)')"
                
                let result = contactDB!.executeUpdate(insertSQL, withArgumentsIn: nil)
                
                if !result {
                    print("Error: \(contactDB!.lastErrorMessage())")
                }
                
            }
            
        }
        
    }
    
    
    
    
    func insertProject(array: NSArray) {
        
        self .connectDb()
        
        //read it
        let contactDB = FMDatabase(path: databasePath as String)
        
        
        if !contactDB!.open() {
            print("Error: \(contactDB!.lastErrorMessage())")
        }
            
        else{
            
            
            
            
            for temp in array {
                
                
                var createdBy:String = ""
                var createdDate:Int = 0
                var ipAddress:String = ""
                var projectCompleted:String = ""
                var projectId:Int = 0
                var projectName:String = ""
                var updatedBy:String = ""
                var updatedDate:Int = 0
                var utilityCompanyId:Int = 0
                
                
                if let value = (temp as AnyObject).object(forKey: "createdBy") as? String{
                    createdBy = value
                }
                if let value = (temp as AnyObject).object(forKey: "createdDate") as? Int{
                    createdDate = value
                }
                
                if let value = (temp as AnyObject).object(forKey: "ipAddress") as? String{
                    ipAddress = value
                }
                if let value = (temp as AnyObject).object(forKey: "projectCompleted") as? String{
                    projectCompleted = value
                }
                if let value = (temp as AnyObject).object(forKey: "projectId") as? Int{
                    projectId = value
                }
                
                if let value = (temp as AnyObject).object(forKey: "updatedBy") as? String{
                    updatedBy = value
                }
                if let value = (temp as AnyObject).object(forKey: "updatedDate") as? Int{
                    updatedDate = value
                }
                if let value = (temp as AnyObject).object(forKey: "utilityCompanyId") as? Int{
                    utilityCompanyId = value
                }
                
                if let value = (temp as AnyObject).object(forKey: "projectName") as? String{
                    projectName = value
                    
                    
                    
                    let insertSQL = "INSERT or REPLACE INTO tblProject (createdBy, createdDate, ipAddress, projectCompleted, projectId, projectName, updatedBy, updatedDate, utilityCompanyId) VALUES ('\(createdBy)', '\(createdDate)','\(ipAddress)', '\(projectCompleted)', '\(projectId)','\(projectName)', '\(updatedBy)', '\(updatedDate)', '\(utilityCompanyId)')"
                    
                    let result = contactDB!.executeUpdate(insertSQL, withArgumentsIn: nil)
                    
                    if !result {
                        print("Error: \(contactDB!.lastErrorMessage())")
                    } else {
                        print("Success")
                        
                    }
                }
                
                
            }
            
        }
        
    }
    
    
    
    
    
    
    
    func insertPredefinedLabel(array: NSArray) {
        
        self .connectDb()
        
        //read it
        let contactDB = FMDatabase(path: databasePath as String)
        
        
        if !contactDB!.open() {
            print("Error: \(contactDB!.lastErrorMessage())")
        }
            
        else{
            
            
            
            
            for temp in array {
                
                var createdBy:String = ""
                var createdDate:Int = 0
                var dataTypeId:Int = 0
                var englishDisplayName:String = ""
                var fieldName:String = ""
                var predefinedLabelId:Int = 0
                var dataCategoryId:Int = 0
                var updatedBy:String = ""
                var updatedDate:Int = 0
                
                
                if let value = (temp as AnyObject).object(forKey: "createdBy") as? String{
                    createdBy = value
                }
                if let value = (temp as AnyObject).object(forKey: "createdDate") as? Int{
                    createdDate = value
                }
                if let value = (temp as AnyObject).object(forKey: "dataTypeId") as? Int{
                    dataTypeId = value
                }
                if let value = (temp as AnyObject).object(forKey: "englishDisplayName") as? String{
                    englishDisplayName = value
                }
                if let value = (temp as AnyObject).object(forKey: "fieldName") as? String{
                    fieldName = value
                }
                if let value = (temp as AnyObject).object(forKey: "predefinedLabelId") as? Int{
                    predefinedLabelId = value
                }
                if let value = (temp as AnyObject).object(forKey: "dataCategoryId") as? Int{
                    dataCategoryId = value
                }
                if let value = (temp as AnyObject).object(forKey: "updatedBy") as? String{
                    updatedBy = value
                }
                if let value = (temp as AnyObject).object(forKey: "updatedDate") as? Int{
                    updatedDate = value
                }
                
                
                let insertSQL = "INSERT or REPLACE INTO tblPredefinedLabel (createdBy, createdDate, dataTypeId, englishDisplayName, fieldName, predefinedLabelId, updatedBy, updatedDate, dataCategoryID) VALUES ('\(createdBy)', '\(createdDate)','\(dataTypeId)', '\(englishDisplayName)', '\(fieldName)','\(predefinedLabelId)', '\(updatedBy)', '\(updatedDate)', '\(dataCategoryId)')"
                
                let result = contactDB!.executeUpdate(insertSQL, withArgumentsIn: nil)
                
                if !result {
                    print("Error: \(contactDB!.lastErrorMessage())")
                }
                
            }
            
        }
        
    }
    
    func insertProductCatalogue(array: NSArray) {
        
        self .connectDb()
        
        //read it
        let contactDB = FMDatabase(path: databasePath as String)
        
        
        if !contactDB!.open() {
            print("Error: \(contactDB!.lastErrorMessage())")
        }
            
        else{
            
            
            
            
            for temp in array {
                
                var createdBy:String = ""
                var createdDate:NSNumber = 0
                var gsId:String = ""
                var instructionSheetURL:String = ""
                var lifeCycleStatus:String = ""
                var productDesc:String = ""
                var productURL:String = ""
                var productVideoURL:String = ""
                var dataSheetURL:String = ""
                var recordTypeId:String = ""
                var shipperUPCCode:String = ""
                var productCategory:String = ""
                var subProductCategory:String = ""
                var unitLevelUPCCode:String = ""
                var updatedBy:String = ""
                var updatedDate:NSNumber = 0
                var upcCode1:String = ""
                var upcCode2:String = ""
                var upcCode3:String = ""
                
                
                
                
                if  let value:String = (temp as AnyObject).object(forKey: "createdBy") as? String{
                    createdBy = value
                }
                if  let value:NSNumber = (temp as AnyObject).object(forKey: "createdDate") as? NSNumber{
                    createdDate = value
                }
                if  let value:String = (temp as AnyObject).object(forKey: "gsId") as? String{
                    gsId = value
                }
                if  let value:String = (temp as AnyObject).object(forKey: "instructionSheetURL") as? String{
                    instructionSheetURL = value
                }
                if  let value:String = (temp as AnyObject).object(forKey: "lifeCycleStatus") as? String{
                    lifeCycleStatus = value
                }
                if  let value:String = (temp as AnyObject).object(forKey: "productDesc") as? String{
                    productDesc = value
                }
                if  let value:String = (temp as AnyObject).object(forKey: "productURL") as? String{
                    productURL = value
                }
                if  let value:String = (temp as AnyObject).object(forKey: "dataSheetURL") as? String{
                    dataSheetURL = value
                }
                if  let value:String = (temp as AnyObject).object(forKey: "productVideoURL") as? String{
                    productVideoURL = value
                }
                if  let value:String = (temp as AnyObject).object(forKey: "recordTypeId") as? String{
                    recordTypeId = value
                }
                if  let value:String = (temp as AnyObject).object(forKey: "shipperUPCCode") as? String{
                    shipperUPCCode = value
                }
                if  let value:String = (temp as AnyObject).object(forKey: "productCategory") as? String{
                    productCategory = value
                }
                if  let value:String = (temp as AnyObject).object(forKey: "subProductCategory") as? String{
                    subProductCategory = value
                }
                if  let value:String = (temp as AnyObject).object(forKey: "unitLevelUPCCode") as? String{
                    unitLevelUPCCode = value
                }
                if  let value:String = (temp as AnyObject).object(forKey: "updatedBy") as? String{
                    updatedBy = value
                }
                if  let value:NSNumber = (temp as AnyObject).object(forKey: "updatedDate") as? NSNumber{
                    updatedDate = value
                }
                if  let value:String = (temp as AnyObject).object(forKey: "upcCode1") as? String{
                    upcCode1 = value
                }
                if  let value:String = (temp as AnyObject).object(forKey: "upcCode2") as? String{
                    upcCode2 = value
                }
                if  let value:String = (temp as AnyObject).object(forKey: "upcCode3") as? String{
                    upcCode3 = value
                }
                
                
                
                let insertSQL = "INSERT or REPLACE INTO tblProductCatalogue (createdBy, createdDate, gsId, instructionSheetURL, lifeCycleStatus, productDesc, productURL, productVideoURL, recordTypeId, shipperUPCCode, productCategory, subProductCategory,unitLevelUPCCode, updatedBy, updatedDate, productImage,dataSheetURL,upcCode1,upcCode2,upcCode3) VALUES ('\(createdBy)','\(createdDate)','\(gsId)','\(instructionSheetURL)','\(lifeCycleStatus)','\(productDesc)','\(productURL)','\(productVideoURL)','\(recordTypeId)','\(shipperUPCCode)','\(productCategory)','\(subProductCategory)','\(unitLevelUPCCode)','\(updatedBy)','\(updatedDate)','','\(dataSheetURL)','\(upcCode1)','\(upcCode2)','\(upcCode3)')"
                
                
                
                let result = contactDB!.executeUpdate(insertSQL, withArgumentsIn: nil)
                
                if !result {
                    print("Error: \(contactDB!.lastErrorMessage())")
                }
                
            }
            
        }
        
    }
    
    
    
    
    func insertRecordType(array: NSArray) {
        
        self .connectDb()
        
        //read it
        let contactDB = FMDatabase(path: databasePath as String)
        
        
        if !contactDB!.open() {
            print("Error: \(contactDB!.lastErrorMessage())")
        }
            
        else{
            
            for temp in array {
                
                
                var createdBy:String = ""
                var createdDate:Int = 0
                var recordTypeDesc:String = ""
                var recordTypeId:Int = 0
                var updatedBy:String = ""
                var updatedDate:Int = 0
                
                
                
                if let value = (temp as AnyObject).object(forKey: "createdBy") as? String{
                    createdBy = value
                }
                if let value = (temp as AnyObject).object(forKey: "createdDate") as? Int{
                    createdDate = value
                }
                if let value = (temp as AnyObject).object(forKey: "recordTypeDesc") as? String{
                    recordTypeDesc = value
                }
                if let value = (temp as AnyObject).object(forKey: "recordTypeId") as? Int{
                    recordTypeId = value
                }
                if let value = (temp as AnyObject).object(forKey: "updatedBy") as? String{
                    updatedBy = value
                }
                if let value = (temp as AnyObject).object(forKey: "updatedDate") as? Int{
                    updatedDate = value
                }
                
                
                
                
                let insertSQL = "INSERT or REPLACE INTO tblRecordType(createdBy, createdDate, recordTypeDesc, recordTypeId, updatedBy, updatedDate) VALUES ('\(createdBy)', '\(createdDate)','\(recordTypeDesc)', '\(recordTypeId)', '\(updatedBy)', '\(updatedDate)')"
                
                let result = contactDB!.executeUpdate(insertSQL, withArgumentsIn: nil)
                
                if !result {
                    print("Error: \(contactDB!.lastErrorMessage())")
                }
                
            }
            
        }
        
    }
    
    
    
    
    
    func insertSecurityQuestion(array: NSArray) {
        
        self .connectDb()
        
        //read it
        let contactDB = FMDatabase(path: databasePath as String)
        
        
        if !contactDB!.open() {
            print("Error: \(contactDB!.lastErrorMessage())")
        }
            
        else{
            
            for temp in array {
                
                var category:Int = 0
                var createdBy:String = ""
                var createdDate:Int = 0
                var question:String = ""
                var securityQuestionId:Int = 0
                var updatedBy:String = ""
                var updatedDate:Int = 0
                
                
                if let value = (temp as AnyObject).object(forKey: "category") as? Int{
                    category = value
                }
                if let value = (temp as AnyObject).object(forKey: "createdBy") as? String{
                    createdBy = value
                }
                if let value = (temp as AnyObject).object(forKey: "createdDate") as? Int{
                    createdDate = value
                }
                if let value = (temp as AnyObject).object(forKey: "question") as? String{
                    question = value.replacingOccurrences(of: "'", with: "''")
                }
                if let value = (temp as AnyObject).object(forKey: "securityQuestionId") as? Int{
                    securityQuestionId = value
                }
                
                if let value = (temp as AnyObject).object(forKey: "updatedBy") as? String{
                    updatedBy = value
                }
                if let value = (temp as AnyObject).object(forKey: "updatedDate") as? Int{
                    updatedDate = value
                }
                
                
                let insertSQL = "INSERT or REPLACE INTO tblSecurityQuestion(category, createdBy, createdDate, question, securityQuestionId, updatedBy, updatedDate) VALUES ('\(category)', '\(createdBy)', '\(createdDate)','\(question)', '\(securityQuestionId)', '\(updatedBy)', '\(updatedDate)')"
                
                let result = contactDB!.executeUpdate(insertSQL, withArgumentsIn: nil)
                
                if !result {
                    print("Error: \(contactDB!.lastErrorMessage())")
                }
                
            }
            
        }
        
    }
    
    
    
    
    
    func insertSmartUser(array: NSArray) {
        
        self .connectDb()
        
        //read it
        let contactDB = FMDatabase(path: databasePath as String)
        
        
        if !contactDB!.open() {
            print("Error: \(contactDB!.lastErrorMessage())")
        }
            
        else{
            
            for temp in array {
                
                var createdBy:String = ""
                var createdDate:Int = 0
                var firstName:String = ""
                var lastName:String = ""
                var password:String = ""
                var primaryEmail:String = ""
                var primaryPhoneNo:String = ""
                var secondaryEmail:String = ""
                var secondaryPhoneNo:String = ""
                var securityAnswer1:String = ""
                var securityAnswer2:String = ""
                var securityQuestion1Id:Int = 0
                var securityQuestion2Id:Int = 0
                var smartUserId:Int = 0
                var superAdmin:String = ""
                var updatedBy:String = ""
                var updatedDate:Int = 0
                var userName:String = ""
                
                
                if let value = (temp as AnyObject).object(forKey: "createdBy") as? String{
                    createdBy = value
                }
                if let value = (temp as AnyObject).object(forKey: "createdDate") as? Int{
                    createdDate = value
                }
                if let value = (temp as AnyObject).object(forKey: "firstName") as? String{
                    firstName = value
                }
                if let value = (temp as AnyObject).object(forKey: "lastName") as? String{
                    lastName = value
                }
                if let value = (temp as AnyObject).object(forKey: "password") as? String{
                    password = value
                }
                if let value = (temp as AnyObject).object(forKey: "primaryEmail") as? String{
                    primaryEmail = value
                }
                if let value = (temp as AnyObject).object(forKey: "primaryPhoneNo") as? String{
                    primaryPhoneNo = value
                }
                if let value = (temp as AnyObject).object(forKey: "secondaryEmail") as? String{
                    secondaryEmail = value
                }
                if let value = (temp as AnyObject).object(forKey: "secondaryPhoneNo") as? String{
                    secondaryPhoneNo = value
                }
                if let value = (temp as AnyObject).object(forKey: "securityAnswer1") as? String{
                    securityAnswer1 = value
                }
                if let value = (temp as AnyObject).object(forKey: "securityAnswer2") as? String{
                    securityAnswer2 = value
                }
                if let value = (temp as AnyObject).object(forKey: "securityQuestion1Id") as? Int{
                    securityQuestion1Id = value
                }
                if let value = (temp as AnyObject).object(forKey: "securityQuestion2Id") as? Int{
                    securityQuestion2Id = value
                }
                if let value = (temp as AnyObject).object(forKey: "smartUserId") as? Int{
                    smartUserId = value
                }
                if let value = (temp as AnyObject).object(forKey: "superAdmin") as? String{
                    superAdmin = value
                }
                if let value = (temp as AnyObject).object(forKey: "updatedBy") as? String{
                    updatedBy = value
                }
                if let value = (temp as AnyObject).object(forKey: "updatedDate") as? Int{
                    updatedDate = value
                }
                if let value = (temp as AnyObject).object(forKey: "userName") as? String{
                    userName = value
                }
                
                
                
                
                
                
                let insertSQL = "INSERT or REPLACE INTO tblSmartUser(createdBy, createdDate, firstName, lastName, password, primaryEmail, primaryPhoneNo, secondaryEmail, secondaryPhoneNo, securityAnswer1, securityAnswer2, securityQuestion1Id, securityQuestion2Id, smartUserId, superAdmin, updatedBy, updatedDate,userName) VALUES ('\(createdBy)', '\(createdDate)','\(firstName)', '\(lastName)', '\(password)', '\(primaryEmail)','\(primaryPhoneNo)','\(secondaryEmail)', '\(secondaryPhoneNo)','\(securityAnswer1)', '\(securityAnswer2)', '\(securityQuestion1Id)', '\(securityQuestion2Id)','\(smartUserId)', '\(superAdmin)', '\(updatedBy)', '\(updatedDate)', '\(userName)')"
                
                let result = contactDB!.executeUpdate(insertSQL, withArgumentsIn: nil)
                
                if !result {
                    print("Error: \(contactDB!.lastErrorMessage())")
                }
                
            }
            
        }
        
    }
    
    
    
    
    
    func insertTemplate(array: NSArray) {
        self .connectDb()
        
        //read it
        let contactDB = FMDatabase(path: databasePath as String)
        
        
        if !contactDB!.open() {
            print("Error: \(contactDB!.lastErrorMessage())")
        }
            
        else{
            
            for temp in array {
                
                
                
                
                
                var createdBy:String = ""
                var createdDate:Int = 0
                var ipAddress:String = ""
                var templateId:Int = 0
                var templateName:String = ""
                var templateTypeId:Int = 0
                var updatedBy:String = ""
                var updatedDate:Int = 0
                var userProfileId:Int = 0
                
                
                
                
                
                if let value = (temp as AnyObject).object(forKey: "createdBy") as? String{
                    createdBy = value
                }
                if let value = (temp as AnyObject).object(forKey: "createdDate") as? Int{
                    createdDate = value
                }
                if let value = (temp as AnyObject).object(forKey: "ipAddress") as? String{
                    ipAddress = value
                }
                if let value = (temp as AnyObject).object(forKey: "templateId") as? Int{
                    templateId = value
                }
                if let value = (temp as AnyObject).object(forKey: "templateName") as? String{
                    templateName = value
                }
                if let value = (temp as AnyObject).object(forKey: "templateTypeId") as? Int{
                    templateTypeId = value
                }
                if let value = (temp as AnyObject).object(forKey: "updatedBy") as? String{
                    updatedBy = value
                }
                if let value = (temp as AnyObject).object(forKey: "updatedDate") as? Int{
                    updatedDate = value
                }
                if let value = (temp as AnyObject).object(forKey: "userProfileId") as? Int{
                    userProfileId = value
                }
                
                
                
                let insertSQL = "INSERT or REPLACE INTO tblTemplate(createdBy, createdDate, ipAddress, templateId,templateName, templateTypeId, updatedBy, updatedDate, userProfileId) VALUES ('\(createdBy)', '\(createdDate)','\(ipAddress)', '\(templateId)', '\(templateName)', '\(templateTypeId)', '\(updatedBy)', '\(updatedDate)', '\(userProfileId)')"
                
                let result = contactDB!.executeUpdate(insertSQL, withArgumentsIn: nil)
                
                if !result {
                    print("Error: \(contactDB!.lastErrorMessage())")
                }
                
            }
            
        }
        
    }
    
    
    
    func insertTemplateDetails(array: NSArray) {
        
        
        self .connectDb()
        
        //read it
        let contactDB = FMDatabase(path: databasePath as String)
        
        
        if !contactDB!.open() {
            print("Error: \(contactDB!.lastErrorMessage())")
        }
            
        else{
            
            for temp in array {
                
                var createdBy:String = ""
                var createdDate:Int = 0
                var labelString:String = ""
                var descriptionString:String = ""
                var labelId:Int = 0
                var descriptionId:Int = 0
                var templateDetailId:Int = 0
                var templateId:Int = 0
                var updatedBy:String = ""
                var updatedDate:Int = 0
                
                if let value = (temp as AnyObject).object(forKey: "createdBy") as? String{
                    createdBy = value
                }
                if let value = (temp as AnyObject).object(forKey: "createdDate") as? Int{
                    createdDate = value
                }
                if let lblId = (temp as AnyObject).object(forKey: "labelId") as? Int{
                    labelId = lblId
                }
                if let descId = (temp as AnyObject).object(forKey: "descriptionId") as? Int{
                    descriptionId = descId
                }
                if let lbl = (temp as AnyObject).object(forKey: "label") as? String{
                    labelString = lbl.replacingOccurrences(of: "'", with: "''")
                }
                if let descString = (temp as AnyObject).object(forKey: "description") as? String{
                    descriptionString = descString
                }
                if let value = (temp as AnyObject).object(forKey: "templateDetailId") as? Int{
                    templateDetailId = value
                }
                if let value = (temp as AnyObject).object(forKey: "templateId") as? Int{
                    templateId = value
                }
                if let value = (temp as AnyObject).object(forKey: "updatedBy") as? String{
                    updatedBy = value
                }
                if let value = (temp as AnyObject).object(forKey: "updatedDate") as? Int{
                    updatedDate = value
                }
                
                
                
                
                
                
                
                
                
                let insertSQL = "INSERT or REPLACE INTO tblTemplateDetails(createdBy, createdDate, descriptionId, labelId,templateDetailId, templateId, updatedBy, updatedDate, description,label) VALUES ('\(createdBy)', '\(createdDate)','\(descriptionId)', '\(labelId)', '\(templateDetailId)', '\(templateId)', '\(updatedBy)', '\(updatedDate)', '\(descriptionString)', '\(labelString)')"
                
                let result = contactDB!.executeUpdate(insertSQL, withArgumentsIn: nil)
                
                if !result {
                    print("Error: \(contactDB!.lastErrorMessage())")
                }
                
            }
            
        }
        
        
    }
    
    
    
    
    
    
    func insertTemplateDetailsAfterAdd(data: [String:Any]) {
        
        
        self .connectDb()
        
        //read it
        let contactDB = FMDatabase(path: databasePath as String)
        
        
        if !contactDB!.open() {
            print("Error: \(contactDB!.lastErrorMessage())")
        }
            
        else{
            
            
            
            let templateId:Int = data["templateId"] as! Int
            let ipAddress:String = data["ipAddress"] as! String
            let templateName:String = data["templateName"] as! String
            let templateTypeId:Int = data["templateTypeId"] as! Int
            let userProfileId:Int = data["userProfileId"] as! Int
            
            
            let array:NSArray = data["templateDetails"] as! NSArray
            for temp in array {
                let createdBy:String = ""
                let createdDate:Int = 0
                var labelString:String = ""
                var descriptionString:String = ""
                var labelId:Int = 0
                var descriptionId:Int = 0
                
                
                if let lblId = (temp as AnyObject).object(forKey: "labelId") as? Int{
                    labelId = lblId
                }
                if let descId = (temp as AnyObject).object(forKey: "descriptionId") as? Int{
                    descriptionId = descId
                }
                if let lbl = (temp as AnyObject).object(forKey: "label") as? String{
                    labelString = lbl
                }
                if let descString = (temp as AnyObject).object(forKey: "description") as? String{
                    descriptionString = descString
                }
                
                
                
                
                
                let insertSQL = "INSERT or REPLACE INTO tblTemplateDetails(descriptionId, labelId, templateId, description, label, createdBy, createdDate) VALUES ('\(descriptionId)', '\(labelId)', '\(templateId)', '\(descriptionString)', '\(labelString)', '\(createdBy)', '\(createdDate)')"
                
                let result = contactDB!.executeUpdate(insertSQL, withArgumentsIn: nil)
                
                if !result {
                    print("Error: \(contactDB!.lastErrorMessage())")
                }
                
                
                
                
                let insertSQL1 = "INSERT or REPLACE INTO tblTemplate(createdBy, createdDate, ipAddress, templateId,templateName, templateTypeId, userProfileId) VALUES ('\(createdBy)', '\(createdDate)','\(ipAddress)', '\(templateId)', '\(templateName)', '\(templateTypeId)', '\(userProfileId)')"
                
                let result1 = contactDB!.executeUpdate(insertSQL1, withArgumentsIn: nil)
                
                if !result1 {
                    print("Error: \(contactDB!.lastErrorMessage())")
                }
                
                
                
            }
            
        }
        
        
    }
    
    
    
    
    func insertTemplateType(array: NSArray) {
        
        
        self .connectDb()
        
        //read it
        let contactDB = FMDatabase(path: databasePath as String)
        
        
        if !contactDB!.open() {
            print("Error: \(contactDB!.lastErrorMessage())")
        }
            
        else{
            
            for temp in array {
                
                
                var createdBy:String = ""
                var createdDate:Int = 0
                var templateTypeDesc:String = ""
                var templateTypeId:Int = 0
                var updatedBy:String = ""
                var updatedDate:Int = 0
                
                
                if let value = (temp as AnyObject).object(forKey: "createdBy") as? String{
                    createdBy = value
                }
                if let value = (temp as AnyObject).object(forKey: "createdDate") as? Int{
                    createdDate = value
                }
                if let value = (temp as AnyObject).object(forKey: "templateTypeDesc") as? String{
                    templateTypeDesc = value
                }
                if let value = (temp as AnyObject).object(forKey: "templateTypeId") as? Int{
                    templateTypeId = value
                }
                if let value = (temp as AnyObject).object(forKey: "updatedBy") as? String{
                    updatedBy = value
                }
                if let value = (temp as AnyObject).object(forKey: "updatedDate") as? Int{
                    updatedDate = value
                }
                
                
                
                let insertSQL = "INSERT or REPLACE INTO tblTemplateType(createdBy, createdDate, templateTypeDesc, templateTypeId, updatedBy, updatedDate) VALUES ('\(createdBy)', '\(createdDate)','\(templateTypeDesc)', '\(templateTypeId)', '\(updatedBy)', '\(updatedDate)')"
                
                let result = contactDB!.executeUpdate(insertSQL, withArgumentsIn: nil)
                
                if !result {
                    print("Error: \(contactDB!.lastErrorMessage())")
                }
                
            }
            
        }
        
        
    }
    
    
    
    
    
    
    func insertUserProfile(array: NSArray) {
        
        
        self .connectDb()
        
        //read it
        let contactDB = FMDatabase(path: databasePath as String)
        
        
        if !contactDB!.open() {
            print("Error: \(contactDB!.lastErrorMessage())")
        }
            
        else{
            
            for temp in array {
                
                var distributorName:String = ""
                var productsBought:String = ""
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                var active:String = ""
                var appLanguageId:Int = 0
                var canCreateNewTemplate:String = ""
                var canCreateNewprojects:String = ""
                var canExportData:String = ""
                var canLookUpInstallerCompanyData:String = ""
                var canLookUpUtilityCompanyData:String = ""
                var canLookupOwnData:String = ""
                var canStoreDataToCloud:String = ""
                var canUseEMSMarker:String = ""
                var canUseCableAccessories:String = ""
                var canUseRFID:String = ""
                var cloudStorage:String = ""
                var functionTypeId:Int = 0
                var glossaryLanguageId:Int = 0
                var inBuiltBCReader:String = ""
                var inBuiltGPS:String = ""
                var smartUserId:Int = 0
                var updatedDate:Int = 0
                var userName:String = ""
                var userProfileId:Int = 0
                var utilityCompanyId:Int = 0
                var installerCompanyId:Int = 0
                var createdBy:String = ""
                var createdDate:Int = 0
                
                
                
                
                
                if let value = (temp as AnyObject).object(forKey: "active") as? String{
                    active = value
                }
                if let value = (temp as AnyObject).object(forKey: "appLanguageId") as? Int{
                    appLanguageId = value
                }
                if let value = (temp as AnyObject).object(forKey: "canCreateNewTemplate") as? String{
                    canCreateNewTemplate = value
                }
                if let value = (temp as AnyObject).object(forKey: "canCreateNewprojects") as? String{
                    canCreateNewprojects = value
                }
                if let value = (temp as AnyObject).object(forKey: "canExportData") as? String{
                    canExportData = value
                }
                if let value = (temp as AnyObject).object(forKey: "canLookUpInstallerCompanyData") as? String{
                    canLookUpInstallerCompanyData = value
                }
                if let value = (temp as AnyObject).object(forKey: "canLookUpUtilityCompanyData") as? String{
                    canLookUpUtilityCompanyData = value
                }
                if let value = (temp as AnyObject).object(forKey: "canLookupOwnData") as? String{
                    canLookupOwnData = value
                }
                if let value = (temp as AnyObject).object(forKey: "canStoreDataToCloud") as? String{
                    canStoreDataToCloud = value
                }
                if let value = (temp as AnyObject).object(forKey: "canUseCableAccessories") as? String{
                    canUseCableAccessories = value
                }
                if let value = (temp as AnyObject).object(forKey: "canUseEMSMarker") as? String{
                    canUseEMSMarker = value
                }
                if let value = (temp as AnyObject).object(forKey: "canUseRFID") as? String{
                    canUseRFID = value
                }
                if let value = (temp as AnyObject).object(forKey: "cloudStorage") as? String{
                    cloudStorage = value
                }
                if let value = (temp as AnyObject).object(forKey: "distributorName") as? String{
                    distributorName = value
                }
                if let value = (temp as AnyObject).object(forKey: "functionTypeId") as? Int{
                    functionTypeId = value
                }
                if let value = (temp as AnyObject).object(forKey: "glossaryLanguageId") as? Int{
                    glossaryLanguageId = value
                }
                if let value = (temp as AnyObject).object(forKey: "inBuiltBCReader") as? String{
                    inBuiltBCReader = value
                }
                if let value = (temp as AnyObject).object(forKey: "inBuiltGPS") as? String{
                    inBuiltGPS = value
                }
                if let value = (temp as AnyObject).object(forKey: "productsBought") as? String{
                    productsBought = value
                }
                if let value = (temp as AnyObject).object(forKey: "createdBy") as? String{
                    createdBy = value
                }
                if let value = (temp as AnyObject).object(forKey: "createdDate") as? Int{
                    createdDate = value
                }
                if let value = (temp as AnyObject).object(forKey: "smartUserId") as? Int{
                    smartUserId = value
                }
                if let value = (temp as AnyObject).object(forKey: "updatedDate") as? Int{
                    updatedDate = value
                }
                if let value = (temp as AnyObject).object(forKey: "userName") as? String{
                    userName = value
                }
                if let value = (temp as AnyObject).object(forKey: "userProfileId") as? Int{
                    userProfileId = value
                }
                if let value = (temp as AnyObject).object(forKey: "utilityCompanyId") as? Int{
                    utilityCompanyId = value
                }
                if let value = (temp as AnyObject).object(forKey: "installerCompanyId") as? Int{
                    installerCompanyId = value
                }
                
                
                let insertSQL = "INSERT or REPLACE INTO tblUserProfile(active, appLanguageId, canCreateNewTemplate, canCreateNewprojects, canExportData, canLookUpInstallerCompanyData, canLookUpUtilityCompanyData, canLookupOwnData, canStoreDataToCloud, canUseCableAccessories, canUseEMSMarker, canUseRFID, cloudStorage, createdBy, createdDate, distributorName, functionTypeId, glossaryLanguageId, inBuiltBCReader, inBuiltGPS, productsBought, smartUserId, updatedDate, userName, userProfileId, utilityCompanyId,installerCompanyID) VALUES ('\(active)', '\(appLanguageId)', '\(canCreateNewTemplate)', '\(canCreateNewprojects)', '\(canExportData)', '\(canLookUpInstallerCompanyData)', '\(canLookUpUtilityCompanyData)', '\(canLookupOwnData)', '\(canStoreDataToCloud)', '\(canUseCableAccessories)', '\(canUseEMSMarker)', '\(canUseRFID)', '\(cloudStorage)', '\(createdBy)', '\(createdDate)', '\(distributorName)', '\(functionTypeId)', '\(glossaryLanguageId)', '\(inBuiltBCReader)', '\(inBuiltGPS)', '\(productsBought)', '\(smartUserId)',  '\(updatedDate)', '\(userName)', '\(userProfileId)', '\(utilityCompanyId)', '\(installerCompanyId)')"
                
                let result = contactDB!.executeUpdate(insertSQL, withArgumentsIn: nil)
                
                if !result {
                    print("Error: \(contactDB!.lastErrorMessage())")
                }
                
            }
            
        }
        
        
    }
    
    
    
    
    
    
    func insertUtilityCompany(array: NSArray) {
        
        self .connectDb()
        
        //read it
        let contactDB = FMDatabase(path: databasePath as String)
        
        
        if !contactDB!.open() {
            print("Error: \(contactDB!.lastErrorMessage())")
        }
            
        else{
            
            for temp in array {
                
                
                var active:String = ""
                var createdBy:String = ""
                var createdDate:NSNumber = 0
                var primaryContactEmail1:String = ""
                var primaryContactFirstName:String = ""
                var primaryContactLastName:String = ""
                var primaryContactPhone1:NSNumber = 0
                var screenLockEnable:String = ""
                var screenLockInactivity:String = ""
                var screenLockPasscode:String = ""
                var sessionTimeOut:String = ""
                var updatedBy:String = ""
                var updatedDate:NSNumber = 0
                var utilityCompanyId:NSNumber = 0
                var utilityCompanyName:String = ""
                var utilityCompanyTypeId:NSNumber = 0
                var verified:String = ""
                
                if let value = (temp as AnyObject).object(forKey: "active") as? String{
                    active = value
                }
                if let value = (temp as AnyObject).object(forKey: "createdBy") as? String{
                    createdBy = value
                }
                if let value = (temp as AnyObject).object(forKey: "createdDate") as? NSNumber{
                    createdDate = value
                }
                if let value = (temp as AnyObject).object(forKey: "primaryContactEmail1") as? String{
                    primaryContactEmail1 = value
                }
                if let value = (temp as AnyObject).object(forKey: "primaryContactFirstName") as? String{
                    primaryContactFirstName = value
                }
                if let value = (temp as AnyObject).object(forKey: "primaryContactLastName") as? String{
                    primaryContactLastName = value
                }
                if let value = (temp as AnyObject).object(forKey: "primaryContactPhone1") as? NSNumber{
                    primaryContactPhone1 = value
                }
                if let value = (temp as AnyObject).object(forKey: "primaryContactPhone1") as? NSNumber{
                    primaryContactPhone1 = value
                }
                if let value = (temp as AnyObject).object(forKey: "screenLockEnable") as? String{
                    screenLockEnable = value
                }
                if let value = (temp as AnyObject).object(forKey: "screenLockInactivity") as? String{
                    screenLockInactivity = value
                }
                if let value = (temp as AnyObject).object(forKey: "screenLockPasscode") as? String{
                    screenLockPasscode = value
                }
                if let value = (temp as AnyObject).object(forKey: "sessionTimeOut") as? String{
                    sessionTimeOut = value
                }
                if let value = (temp as AnyObject).object(forKey: "updatedBy") as? String{
                    updatedBy = value
                }
                if let value = (temp as AnyObject).object(forKey: "utilityCompanyId") as? NSNumber{
                    utilityCompanyId = value
                }
                if let value = (temp as AnyObject).object(forKey: "utilityCompanyName") as? String{
                    utilityCompanyName = value
                }
                if let value = (temp as AnyObject).object(forKey: "updatedDate") as? NSNumber{
                    updatedDate = value
                }
                if let value = (temp as AnyObject).object(forKey: "utilityCompanyTypeId") as? NSNumber{
                    utilityCompanyTypeId = value
                }
                if let value = (temp as AnyObject).object(forKey: "verified") as? String{
                    verified = value
                }
                
                
                
                let insertSQL = "INSERT or REPLACE INTO tblUtilityCompany( active, createdBy, createdDate, primaryContactEmail1, primaryContactFirstName, primaryContactLastName, primaryContactPhone1, screenLockEnable, screenLockInactivity, screenLockPasscode, sessionTimeOut, updatedBy, updatedDate, utilityCompanyId, utilityCompanyName, utilityCompanyTypeId, verified) VALUES ('\(active)', '\(createdBy)', '\(createdDate)', '\(primaryContactEmail1)', '\(primaryContactFirstName)', '\(primaryContactLastName)', '\(primaryContactPhone1)', '\(screenLockEnable)', '\(screenLockInactivity)', '\(screenLockPasscode)', '\(sessionTimeOut)', '\(updatedBy)', '\(updatedDate)', '\(utilityCompanyId)', '\(utilityCompanyName)', '\(utilityCompanyTypeId)', '\(verified)')"
                
                let result = contactDB!.executeUpdate(insertSQL, withArgumentsIn: nil)
                
                if !result {
                    print("Error: \(contactDB!.lastErrorMessage())")
                }
                
            }
            
        }
        
    }
    
    
    
    
    func insertUtilityCompanyType(array: NSArray) {
        
        self .connectDb()
        
        //read it
        let contactDB = FMDatabase(path: databasePath as String)
        
        
        if !contactDB!.open() {
            print("Error: \(contactDB!.lastErrorMessage())")
        }
            
        else{
            
            
            
            for temp in array {
                
                var createdBy:String = ""
                var createdDate:Int = 0
                var updatedBy:String = ""
                var updatedDate:Int = 0
                var utilityCompanyTypeDesc:String = ""
                var utilityCompanyTypeId:Int = 0
                
                
                if let value = (temp as AnyObject).object(forKey: "createdBy") as? String{
                    createdBy = value
                }
                if let value = (temp as AnyObject).object(forKey: "createdDate") as? Int{
                    createdDate = value
                }
                if let value = (temp as AnyObject).object(forKey: "updatedBy") as? String{
                    updatedBy = value
                }
                if let value = (temp as AnyObject).object(forKey: "updatedDate") as? Int{
                    updatedDate = value
                }
                if let value = (temp as AnyObject).object(forKey: "utilityCompanyTypeDesc") as? String{
                    utilityCompanyTypeDesc = value
                }
                if let value = (temp as AnyObject).object(forKey: "utilityCompanyTypeId") as? Int{
                    utilityCompanyTypeId = value
                }
                
                
                let insertSQL = "INSERT or REPLACE INTO tblUtilityCompanyType (createdBy, createdDate, updatedBy, updatedDate, utilityCompanyTypeDesc, utilityCompanyTypeId) VALUES ('\(createdBy)', '\(createdDate)','\(updatedBy)', '\(updatedDate)', '\(utilityCompanyTypeDesc)','\(utilityCompanyTypeId)')"
                
                let result = contactDB!.executeUpdate(insertSQL, withArgumentsIn: nil)
                
                if !result {
                    print("Error: \(contactDB!.lastErrorMessage())")
                }
                
            }
            
        }
        
    }
    
    func getPredefinedLabelId(Template: String) -> NSArray {
        
        self .connectDb()
        mutableArray = NSMutableArray()
        
        let contactDB = FMDatabase(path: databasePath as String)
        
        
        if (contactDB!.open()) {
            var querySQL = ""
            
            if Template == "RFID" {
                querySQL = "SELECT * FROM tblPredefinedLabel where dataCategoryID = '1'"
            }
            else
            {
                querySQL = "SELECT * FROM tblPredefinedLabel where dataCategoryID > '1'"
            }
            
            
            
            let results:FMResultSet? = contactDB?.executeQuery(querySQL, withArgumentsIn: nil)
            
            while ((results?.next()) == true) {
                mutableArray .add(results!.string(forColumn: "predefinedLabelID"))
            }
            contactDB?.close()
        } else {
            print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
        }
        
        print(databasePath)
        return mutableArray as NSArray
        
    }
    
    
    
    func getPredefinedLabelName(labelIdArray: NSArray) -> NSArray {
        
        self .connectDb()
        let contactDB = FMDatabase(path: databasePath as String)
        
        let languageArray:NSArray = self.getGlossaryLanguageSettings()
        let languageId:String = languageArray .object(at: 0) as! String
        
        
        
        if (contactDB!.open()) {
            
            mutableArray = NSMutableArray()
            
            for i in 0 ..< labelIdArray.count {
                
                let querySQL = "SELECT * FROM tblLabelTranslation where languageID = '\(languageId)' and predefinedLabelID = '\(labelIdArray .object(at: i))'"
                let results:FMResultSet? = contactDB?.executeQuery(querySQL, withArgumentsIn: nil)
                if ((results?.next()) == true) {
                    mutableArray .add(results!.string(forColumn: "languageDisplayName"))
                }
                
            }
            
            contactDB?.close()
            
            
            var swiftArray = mutableArray as AnyObject as! [String]
            swiftArray.sort {
                $0.compare($1, options: .numeric) == .orderedAscending
            }
            // mutableArray = swiftArray as! NSMutableArray
            
            mutableArray = NSMutableArray(array:swiftArray)
            
            
            
        } else {
            print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
        }
        
        print(databasePath)
        return mutableArray as NSArray
        
    }
    
    
    
    
    
    
    func getPredefinedLabel(LabelName: String) -> NSArray {
        
        self .connectDb()
        
        
        let contactDB = FMDatabase(path: databasePath as String)
        
        var array:NSArray = []
        
        
        let languageArray:NSArray = self.getGlossaryLanguageSettings()
        let languageId:String = languageArray .object(at: 0) as! String
        
        
        if (contactDB!.open()) {
            let querySQL = "SELECT * FROM tblLabelTranslation where languageDisplayName = '\(LabelName)' and languageID = '\(languageId)'"
            
            
            let results:FMResultSet? = contactDB?.executeQuery(querySQL, withArgumentsIn: nil)
            
            
            while ((results?.next()) == true) {
                
                let labelId:String = results!.string(forColumn: "predefinedLabelID")
                let dataTypeId:String = self .getDataTypeId(labelId: labelId)
                
                
                array = [labelId, dataTypeId]
            }
            contactDB?.close()
            
            
        } else {
            print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
        }
        
        
        
        print(array)
        
        print(databasePath)
        return array
        
    }
    
    //    func getPredefinedLabel(LabelName: String) -> NSArray {
    //
    //        self .connectDb()
    //
    //
    //        let contactDB = FMDatabase(path: databasePath as String)
    //
    //        var array:NSArray = []
    //
    //
    //        if (contactDB!.open()) {
    //            let querySQL = "SELECT * FROM tblPredefinedLabel where fieldName = '\(LabelName)'"
    //
    //            let results:FMResultSet? = contactDB?.executeQuery(querySQL, withArgumentsIn: nil)
    //
    //
    //            while ((results?.next()) == true) {
    //                array = [results!.string(forColumn: "predefinedLabelID"), results!.string(forColumn: "dataTypeID")]
    //            }
    //            contactDB?.close()
    //
    //
    //        } else {
    //            print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
    //        }
    //
    //
    //
    //        print(array)
    //
    //        print(databasePath)
    //        return array
    //
    //    }
    
    
    func getDataType(DataTypeID: String) -> String {
        
        self .connectDb()
        
        let contactDB = FMDatabase(path: databasePath as String)
        
        var dataType:String = ""
        
        if (contactDB!.open()) {
            let querySQL = "SELECT * FROM tblDataType where dataTypeID = '\(DataTypeID)'"
            
            let results:FMResultSet? = contactDB?.executeQuery(querySQL, withArgumentsIn: nil)
            
            
            while ((results?.next()) == true) {
                dataType = results!.string(forColumn: "dataType")
            }
            contactDB?.close()
            
        } else {
            print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
        }
        
        print(databasePath)
        return dataType
        
    }
    
    func getDescriptionIdArray(LabelId: String) -> NSMutableArray {
        
        self .connectDb()
        
        mutableArray = NSMutableArray()
        
        let contactDB = FMDatabase(path: databasePath as String)
        
        
        if (contactDB!.open()) {
            let querySQL = "SELECT * FROM tblLabelVsDescXREF where predefinedLabelID = '\(LabelId)'"
            
            let results:FMResultSet? = contactDB?.executeQuery(querySQL, withArgumentsIn: nil)
            
            
            while ((results?.next()) == true) {
                
                mutableArray .add(results!.string(forColumn: "predefinedDescriptionID"))
            }
            contactDB?.close()
            
        } else {
            print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
        }
        
        print(databasePath)
        return mutableArray
        
    }
    
    func getLanguageArray() -> NSMutableArray {
        
        self .connectDb()
        
        mutableArray = NSMutableArray()
        
        let contactDB = FMDatabase(path: databasePath as String)
        
        let languageIdArray = NSMutableArray()
        let languageNameArray = NSMutableArray()
        
        
        
        if (contactDB!.open()) {
            let querySQL = "SELECT * FROM tblLanguage"
            
            let results:FMResultSet? = contactDB?.executeQuery(querySQL, withArgumentsIn: nil)
            
            
            while ((results?.next()) == true) {
                languageIdArray .add(results!.string(forColumn: "languageId"))
                languageNameArray .add(results!.string(forColumn: "LanguageName"))
            }
            contactDB?.close()
            
        } else {
            print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
        }
        
        mutableArray.add(languageIdArray)
        mutableArray.add(languageNameArray)
        
        
        print(databasePath)
        return mutableArray
        
    }
    
    
    
    
    func getLanguageId(LanguageName: String) -> String {
        
        self .connectDb()
        
        let contactDB = FMDatabase(path: databasePath as String)
        
        var languageId:String = ""
        
        
        
        if (contactDB!.open()) {
            let querySQL = "SELECT * FROM tblLanguage where LanguageName = '\(LanguageName)'"
            
            let results:FMResultSet? = contactDB?.executeQuery(querySQL, withArgumentsIn: nil)
            
            
            while ((results?.next()) == true) {
                languageId = (results!.string(forColumn: "languageId"))
            }
            contactDB?.close()
            
        } else {
            print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
        }
        
        
        
        print(databasePath)
        return languageId
    }
    
    
    
    func getDescriptionId(DescriptionName: String) -> String {
        
        self .connectDb()
        
        var predefinedDescriptionID:String = ""
        let contactDB = FMDatabase(path: databasePath as String)
        
        
        let languageArray:NSArray = self.getGlossaryLanguageSettings()
        let languageId:String = languageArray .object(at: 0) as! String
        
        
        
        
        if (contactDB!.open()) {
            
            
            let querySQL = "SELECT * FROM tblDescriptionTranslation where languageDisplayName = '\(DescriptionName)' and languageID = '\(languageId)'"
            
            let results:FMResultSet? = contactDB?.executeQuery(querySQL, withArgumentsIn: nil)
            
            while ((results?.next()) == true) {
                
                predefinedDescriptionID = results!.string(forColumn: "predefinedDescriptionID")
            }
            contactDB?.close()
            
        } else {
            print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
        }
        
        print(databasePath)
        return predefinedDescriptionID
        
    }
    
    
    
    
    
    
    
    //    func getDescriptionId(DescriptionName: String) -> String {
    //
    //        self .connectDb()
    //
    //        var predefinedDescriptionID:String = ""
    //
    //        let contactDB = FMDatabase(path: databasePath as String)
    //
    //
    //        if (contactDB!.open()) {
    //            let querySQL = "SELECT * FROM tblPredefinedDescription where englishDisplayName = '\(DescriptionName)'"
    //
    //            let results:FMResultSet? = contactDB?.executeQuery(querySQL, withArgumentsIn: nil)
    //
    //            while ((results?.next()) == true) {
    //
    //                predefinedDescriptionID = results!.string(forColumn: "predefinedDescriptionID")
    //            }
    //            contactDB?.close()
    //
    //        } else {
    //            print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
    //        }
    //
    //        print(databasePath)
    //        return predefinedDescriptionID
    //
    //    }
    
    
    //    func getDescriptionArray(DescriptionIdArray: NSArray) -> NSMutableArray {
    //
    //        self .connectDb()
    //
    //        mutableArray = NSMutableArray()
    //
    //        let contactDB = FMDatabase(path: databasePath as String)
    //
    //
    //        if (contactDB!.open()) {
    //
    //
    //             for i in 0 ..< DescriptionIdArray.count {
    //
    //            let querySQL = "SELECT * FROM tblPredefinedDescription where predefinedDescriptionID = '\(DescriptionIdArray[i])'"
    //
    //            let results:FMResultSet? = contactDB?.executeQuery(querySQL, withArgumentsIn: nil)
    //                while ((results?.next()) == true) {
    //             mutableArray .add(results!.string(forColumn: "englishDisplayName"))
    //                }
    //            }
    //            contactDB?.close()
    //
    //        } else {
    //            print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
    //        }
    //
    //        return mutableArray
    //
    //    }
    
    
    
    func getDescriptionArray(DescriptionIdArray: NSArray) -> NSMutableArray {
        
        self .connectDb()
        
        
        let contactDB = FMDatabase(path: databasePath as String)
        
        let languageArray:NSArray = self.getGlossaryLanguageSettings()
        let languageId:String = languageArray .object(at: 0) as! String
        
        
        if (contactDB!.open()) {
            
            
            mutableArray = NSMutableArray()
            
            for i in 0 ..< DescriptionIdArray.count {
                
                let querySQL2 = "SELECT * FROM tblDescriptionTranslation where predefinedDescriptionID = '\(DescriptionIdArray[i])' and languageID = '\(languageId)'"
                
                print(querySQL2)
                
                
                let results2:FMResultSet? = contactDB?.executeQuery(querySQL2, withArgumentsIn: nil)
                if (results2?.next() == true) {
                    mutableArray .add(results2!.string(forColumn: "languageDisplayName"))
                }
            }
            contactDB?.close()
            
            
            var swiftArray = mutableArray as AnyObject as! [String]
            swiftArray.sort {
                $0.compare($1, options: .numeric) == .orderedAscending
            }
            // mutableArray = swiftArray as! NSMutableArray
            mutableArray = NSMutableArray(array:swiftArray)
            
            
        } else {
            print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
        }
        
        return mutableArray
        
    }
    
    
    
    
    
    
    func getTemplateName(TemplateTypeId: String) -> NSMutableArray {
        
        self .connectDb()
        
        mutableArray = NSMutableArray()
        let contactDB = FMDatabase(path: databasePath as String)
        
        if (contactDB!.open()) {
            let querySQL = "SELECT * FROM tblTemplate where templateTypeId = '\(TemplateTypeId)' order by templateName"
            
            let results:FMResultSet? = contactDB?.executeQuery(querySQL, withArgumentsIn: nil)
            
            while ((results?.next()) == true) {
                
                mutableArray .add(results!.string(forColumn: "templateName"))
            }
            contactDB?.close()
            
        } else {
            print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
        }
        return mutableArray
    }
    
    
    func getTemplateId(TemplateName: String) -> NSMutableArray {
        
        self .connectDb()
        
        mutableArray = NSMutableArray()
        let contactDB = FMDatabase(path: databasePath as String)
        
        
        
        if (contactDB!.open()) {
            let querySQL = "SELECT * FROM tblTemplate where templateName = '\(TemplateName)'"
            let results:FMResultSet? = contactDB?.executeQuery(querySQL, withArgumentsIn: nil)
            
            while (results?.next() == true) {
                mutableArray .add(results!.string(forColumn: "templateId"))
                mutableArray .add(results!.string(forColumn: "templateTypeId"))
                
            }
            
            
            contactDB?.close()
            
        } else {
            print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
        }
        
        print(databasePath)
        return mutableArray
        
    }
    
    
    //
    //    func getLabelDescriptionArray(TemplateId: String) -> NSMutableArray {
    //
    //        self .connectDb()
    //
    //        let contactDB = FMDatabase(path: databasePath as String)
    //
    //        mutableArray = NSMutableArray()
    //        var labelArray = NSMutableArray()
    //        var descriptionArray = NSMutableArray()
    //        var dropdownArray = NSMutableArray()
    //        let templateDetailIdArray = NSMutableArray()
    //
    //
    //        labelArray = ["","","","","",""]
    //        descriptionArray = ["","","","","",""]
    //        dropdownArray = ["","","","","",""]
    //
    //
    //        if (contactDB!.open()) {
    //
    //        let querySQL1 = "SELECT * FROM tblTemplateDetails where templateId = '\(TemplateId)'"
    //        let results1:FMResultSet? = contactDB?.executeQuery(querySQL1, withArgumentsIn: nil)
    //
    //
    //
    //            var row:Int = 0
    //
    //            while (results1?.next() == true) {
    //
    //                templateDetailIdArray .add(results1!.string(forColumn: "templateDetailId"))
    //
    //                let labelId:String = results1!.string(forColumn: "labelId")
    //                let descriptionId:String = results1!.string(forColumn: "descriptionId")
    //
    //
    //                print(results1!.string(forColumn: "description"))
    //
    //
    //
    //                if (labelId == "0" && descriptionId == "0") {
    //
    //                    if row > 5 {
    //                        labelArray .add(results1!.string(forColumn: "label"))
    //                        descriptionArray .add(results1!.string(forColumn: "description"))
    //                        dropdownArray .add("")
    //
    //                    }
    //                    else{
    //                    labelArray.replaceObject(at: row, with: results1!.string(forColumn: "label"))
    //                    descriptionArray.replaceObject(at: row, with: results1!.string(forColumn: "description"))
    //
    //                    }
    //
    //
    //
    //
    //                }
    //                else if (labelId != "0")
    //                {
    //
    //
    //                    let querySQL2 = "SELECT * FROM tblPredefinedLabel where predefinedLabelID = '\(labelId)'"
    //                    let results2:FMResultSet? = contactDB?.executeQuery(querySQL2, withArgumentsIn: nil)
    //                    if (results2?.next() == true){
    //                         if row > 5 {
    //                            labelArray .add(results2!.string(forColumn: "englishDisplayName"))
    //                            dropdownArray .add("")
    //                        }
    //                        else
    //                        {
    //                            labelArray.replaceObject(at: row, with: results2!.string(forColumn: "englishDisplayName"))
    //                            let dataType:String = self .getDataType(DataTypeID: results2!.string(forColumn: "dataTypeID"))
    //                            dropdownArray.replaceObject(at: row, with: dataType)
    //                        }
    //
    //                    }
    //
    //
    //                    if (descriptionId != "0"){
    //
    //                        let querySQL3 = "SELECT * FROM tblPredefinedDescription where predefinedDescriptionID = '\(descriptionId)'"
    //                        let results3:FMResultSet? = contactDB?.executeQuery(querySQL3, withArgumentsIn: nil)
    //                        if (results3?.next() == true){
    //                            if row > 5 {
    //                                descriptionArray .add(results3!.string(forColumn: "englishDisplayName"))
    //                            }
    //                            else{
    //                            descriptionArray.replaceObject(at: row, with: results3!.string(forColumn: "englishDisplayName"))
    //                            }
    //                        }
    //
    //                    }
    //                    else
    //                    {
    //                        if row > 5 {
    //                            descriptionArray .add(results1!.string(forColumn: "description"))
    //
    //                        }
    //                        else{
    //                            descriptionArray.replaceObject(at: row, with: results1!.string(forColumn: "description"))
    //                        }
    //                    }
    //
    //                }
    //
    //
    //                row += 1
    //
    //            }
    //
    //        mutableArray .add(labelArray)
    //        mutableArray .add(descriptionArray)
    //        mutableArray .add(dropdownArray)
    //        mutableArray .add(templateDetailIdArray)
    //
    //
    //
    //
    //            contactDB?.close()
    //
    //        } else {
    //            print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
    //        }
    //
    //        print(databasePath)
    //        return mutableArray
    //
    //    }
    
    
    
    
    func getLabelDescriptionArray(TemplateId: String) -> NSMutableArray {
        
        self .connectDb()
        
        let contactDB = FMDatabase(path: databasePath as String)
        
        var labelArray = NSMutableArray()
        var descriptionArray = NSMutableArray()
        var dropdownArray = NSMutableArray()
        let templateDetailIdArray = NSMutableArray()
        
        
        labelArray = ["","","","","",""]
        descriptionArray = ["","","","","",""]
        dropdownArray = ["","","","","",""]
        
        
        let languageArray:NSArray = self.getGlossaryLanguageSettings()
        let languageId:String = languageArray .object(at: 0) as! String
        
        
        
        
        if (contactDB!.open()) {
            
            let querySQL1 = "SELECT * FROM tblTemplateDetails where templateId = '\(TemplateId)'"
            let results1:FMResultSet? = contactDB?.executeQuery(querySQL1, withArgumentsIn: nil)
            
            
            
            var row:Int = 0
            
            while (results1?.next() == true) {
                
                templateDetailIdArray .add(results1!.string(forColumn: "templateDetailId"))
                
                let labelId:String = results1!.string(forColumn: "labelId")
                let descriptionId:String = results1!.string(forColumn: "descriptionId")
                
                
                print(results1!.string(forColumn: "description"))
                
                
                
                if (labelId == "0" && descriptionId == "0") {
                    
                    if row > 5 {
                        labelArray .add(results1!.string(forColumn: "label"))
                        descriptionArray .add(results1!.string(forColumn: "description"))
                        dropdownArray .add("")
                        
                    }
                    else{
                        labelArray.replaceObject(at: row, with: results1!.string(forColumn: "label"))
                        descriptionArray.replaceObject(at: row, with: results1!.string(forColumn: "description"))
                        
                    }
                    
                    
                    
                    
                }
                else if (labelId != "0")
                {
                    
                    let querySQL2 = "SELECT * FROM tblLabelTranslation where predefinedLabelID = '\(labelId)' and languageID = '\(languageId)'"
                    
                    
                    let results2:FMResultSet? = contactDB?.executeQuery(querySQL2, withArgumentsIn: nil)
                    if (results2?.next() == true){
                        if row > 5 {
                            labelArray .add(results2!.string(forColumn: "languageDisplayName"))
                            dropdownArray .add("")
                        }
                        else
                        {
                            labelArray.replaceObject(at: row, with: results2!.string(forColumn: "languageDisplayName"))
                            
                            let dataTypeId:String = self .getDataTypeId(labelId: labelId)
                            let dataType:String = self .getDataType(DataTypeID: dataTypeId)
                            
                            dropdownArray.replaceObject(at: row, with: dataType)
                        }
                        
                    }
                    
                    
                    
                    
                    
                    
                    if (descriptionId != "0"){
                        
                        let querySQL3 = "SELECT * FROM tblDescriptionTranslation where predefinedDescriptionID = '\(descriptionId)' and languageID = '\(languageId)'"
                        let results3:FMResultSet? = contactDB?.executeQuery(querySQL3, withArgumentsIn: nil)
                        if (results3?.next() == true){
                            if row > 5 {
                                descriptionArray .add(results3!.string(forColumn: "languageDisplayName"))
                            }
                            else{
                                descriptionArray.replaceObject(at: row, with: results3!.string(forColumn: "languageDisplayName"))
                            }
                        }
                        
                    }
                    else
                    {
                        if row > 5 {
                            descriptionArray .add(results1!.string(forColumn: "description"))
                            
                        }
                        else{
                            descriptionArray.replaceObject(at: row, with: results1!.string(forColumn: "description"))
                        }
                    }
                    
                }
                
                
                row += 1
                
            }
            
            mutableArray = NSMutableArray()
            mutableArray .add(labelArray)
            mutableArray .add(descriptionArray)
            mutableArray .add(dropdownArray)
            mutableArray .add(templateDetailIdArray)
            
            
            print(labelArray)
            print(descriptionArray)
            print(dropdownArray)
            print(templateDetailIdArray)
            
            
            
            
            contactDB?.close()
            
        } else {
            print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
        }
        
        print(databasePath)
        return mutableArray
        
    }
    
    
    func getLabelDescriptionArray1(TemplateId: String) -> NSMutableArray {
        
        self .connectDb()
        
        let contactDB = FMDatabase(path: databasePath as String)
        
        let labelArray = NSMutableArray()
        let descriptionArray = NSMutableArray()
        let dropdownArray = NSMutableArray()
        let templateDetailIdArray = NSMutableArray()
        
        
        
        let languageArray:NSArray = self.getGlossaryLanguageSettings()
        let languageId:String = languageArray .object(at: 0) as! String
        
        
        
        if (contactDB!.open()) {
            
            let querySQL1 = "SELECT * FROM tblTemplateDetails where templateId = '\(TemplateId)'"
            let results1:FMResultSet? = contactDB?.executeQuery(querySQL1, withArgumentsIn: nil)
            
            
            
            while (results1?.next() == true) {
                
                templateDetailIdArray .add(results1!.string(forColumn: "templateDetailId"))
                
                let labelId:String = results1!.string(forColumn: "labelId")
                let descriptionId:String = results1!.string(forColumn: "descriptionId")
                
                
                print(results1!.string(forColumn: "description"))
                
                
                
                if (labelId == "0" && descriptionId == "0") {
                    
                    labelArray .add(results1!.string(forColumn: "label"))
                    descriptionArray .add(results1!.string(forColumn: "description"))
                    dropdownArray .add("")
                    
                }
                else if (labelId != "0")
                {
                    
                    
                    let querySQL2 = "SELECT * FROM tblLabelTranslation where predefinedLabelID = '\(labelId)' and languageID = '\(languageId)'"
                    
                    
                    let results2:FMResultSet? = contactDB?.executeQuery(querySQL2, withArgumentsIn: nil)
                    if (results2?.next() == true){
                        labelArray .add(results2!.string(forColumn: "languageDisplayName"))
                        
                        let dataTypeId:String = self .getDataTypeId(labelId: labelId)
                        let dataType:String = self .getDataType(DataTypeID: dataTypeId)
                        dropdownArray .add(dataType)
                    }
                    
                    
                    
                    
                    if (descriptionId != "0"){
                        
                        let querySQL3 = "SELECT * FROM tblDescriptionTranslation where predefinedDescriptionID = '\(descriptionId)' and languageID = '\(languageId)'"
                        
                        
                        
                        let results3:FMResultSet? = contactDB?.executeQuery(querySQL3, withArgumentsIn: nil)
                        if (results3?.next() == true){
                            descriptionArray .add(results3!.string(forColumn: "languageDisplayName"))
                        }
                        
                    }
                    else
                    {
                        descriptionArray .add(results1!.string(forColumn: "description"))
                        
                    }
                    
                }
                
                
                
            }
            
            mutableArray = NSMutableArray()
            mutableArray .add(labelArray)
            mutableArray .add(descriptionArray)
            mutableArray .add(dropdownArray)
            mutableArray .add(templateDetailIdArray)
            
            
            
            
            contactDB?.close()
            
        } else {
            print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
        }
        
        print(databasePath)
        return mutableArray
        
    }
    
    
    func getDataTypeId(labelId: String) -> String {
        
        self .connectDb()
        
        
        let contactDB = FMDatabase(path: databasePath as String)
        
        var dataTypeID:String = ""
        
        
        if (contactDB!.open()) {
            let querySQL = "SELECT * FROM tblPredefinedLabel where predefinedLabelID = '\(labelId)'"
            
            let results:FMResultSet? = contactDB?.executeQuery(querySQL, withArgumentsIn: nil)
            
            
            if ((results?.next()) == true) {
                dataTypeID = results!.string(forColumn: "dataTypeID")
            }
            contactDB?.close()
            
            
        } else {
            print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
        }
        
        
        
        
        print(databasePath)
        return dataTypeID
        
    }
    
    
    
    
    
    
    //    func getLabelDescriptionArray1(TemplateId: String) -> NSMutableArray {
    //
    //        self .connectDb()
    //
    //        let contactDB = FMDatabase(path: databasePath as String)
    //
    //        mutableArray = NSMutableArray()
    //        let labelArray = NSMutableArray()
    //        let descriptionArray = NSMutableArray()
    //        let dropdownArray = NSMutableArray()
    //        let templateDetailIdArray = NSMutableArray()
    //
    //
    //
    //        if (contactDB!.open()) {
    //
    //            let querySQL1 = "SELECT * FROM tblTemplateDetails where templateId = '\(TemplateId)'"
    //            let results1:FMResultSet? = contactDB?.executeQuery(querySQL1, withArgumentsIn: nil)
    //
    //
    //
    //            while (results1?.next() == true) {
    //
    //                templateDetailIdArray .add(results1!.string(forColumn: "templateDetailId"))
    //
    //                let labelId:String = results1!.string(forColumn: "labelId")
    //                let descriptionId:String = results1!.string(forColumn: "descriptionId")
    //
    //
    //                print(results1!.string(forColumn: "description"))
    //
    //
    //
    //                if (labelId == "0" && descriptionId == "0") {
    //
    //                        labelArray .add(results1!.string(forColumn: "label"))
    //                        descriptionArray .add(results1!.string(forColumn: "description"))
    //                        dropdownArray .add("")
    //
    //                }
    //                else if (labelId != "0")
    //                {
    //
    //
    //                    let querySQL2 = "SELECT * FROM tblPredefinedLabel where predefinedLabelID = '\(labelId)'"
    //                    let results2:FMResultSet? = contactDB?.executeQuery(querySQL2, withArgumentsIn: nil)
    //                    if (results2?.next() == true){
    //                            labelArray .add(results2!.string(forColumn: "englishDisplayName"))
    //
    //                        let dataType:String = self .getDataType(DataTypeID: results2!.string(forColumn: "dataTypeID"))
    //                          dropdownArray .add(dataType)
    //
    //                    }
    //
    //
    //                    if (descriptionId != "0"){
    //
    //                        let querySQL3 = "SELECT * FROM tblPredefinedDescription where predefinedDescriptionID = '\(descriptionId)'"
    //                        let results3:FMResultSet? = contactDB?.executeQuery(querySQL3, withArgumentsIn: nil)
    //                        if (results3?.next() == true){
    //                                descriptionArray .add(results3!.string(forColumn: "englishDisplayName"))
    //
    //                        }
    //
    //                    }
    //                    else
    //                    {
    //                            descriptionArray .add(results1!.string(forColumn: "description"))
    //
    //                    }
    //
    //                }
    //
    //
    //
    //            }
    //
    //            mutableArray .add(labelArray)
    //            mutableArray .add(descriptionArray)
    //            mutableArray .add(dropdownArray)
    //            mutableArray .add(templateDetailIdArray)
    //
    //
    //
    //
    //            contactDB?.close()
    //
    //        } else {
    //            print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
    //        }
    //
    //        print(databasePath)
    //        return mutableArray
    //
    //    }
    //
    
    
    
    
    func getProjectArray() -> NSMutableArray {
        
        self .connectDb()
        
        let contactDB = FMDatabase(path: databasePath as String)
        
        mutableArray = NSMutableArray()
        let projectArray = NSMutableArray()
        let projectIdArray = NSMutableArray()
        
        
        
        if (contactDB!.open()) {
            let querySQL = "SELECT * FROM tblProject order by projectName"
            
            let results:FMResultSet? = contactDB?.executeQuery(querySQL, withArgumentsIn: nil)
            
            while ((results?.next()) == true) {
                
                projectArray .add(results!.string(forColumn: "projectName"))
                projectIdArray .add(results!.string(forColumn: "projectID"))
                
            }
            
            mutableArray .add(projectArray)
            mutableArray .add(projectIdArray)
            
            
            contactDB?.close()
            
        } else {
            print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
        }
        
        print(databasePath)
        return mutableArray
        
    }
    
    
    func getProjectId(projectName:String) -> String {
        
        self .connectDb()
        
        let contactDB = FMDatabase(path: databasePath as String)
        
        var projectId:String = ""
        
        if (contactDB!.open()) {
            let querySQL = "SELECT * FROM tblProject where projectName = '\(projectName)'"
            
            let results:FMResultSet? = contactDB?.executeQuery(querySQL, withArgumentsIn: nil)
            
            if ((results?.next()) == true) {
                
                projectId = results!.string(forColumn: "projectID")
                
            }
            
            
            
            contactDB?.close()
            
        } else {
            print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
        }
        
        return projectId
        
    }
    
    
    
    
    func canCreateNewProjects() -> String {
        
        self .connectDb()
        
        let contactDB = FMDatabase(path: databasePath as String)
        
        var canCreateNewProjects:String = ""
        
        if (contactDB!.open()) {
            let querySQL = "SELECT * FROM tblUserProfile"
            
            let results:FMResultSet? = contactDB?.executeQuery(querySQL, withArgumentsIn: nil)
            
            while ((results?.next()) == true) {
                
                canCreateNewProjects = results!.string(forColumn: "canCreateNewProjects")
            }
            
            contactDB?.close()
            
        } else {
            print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
        }
        
        return canCreateNewProjects
        
    }
    
    
    
    
    func getProductCatalogue(recordTypeID: String) -> NSMutableArray {
        
        self .connectDb()
        
        let contactDB = FMDatabase(path: databasePath as String)
        
        let productCategoryArray = NSMutableArray()
        
        
        if (contactDB!.open()) {
            let querySQL = "SELECT DISTINCT productCategory from tblProductCatalogue where recordTypeID = '\(recordTypeID)' order by productCategory"
            
            let results:FMResultSet? = contactDB?.executeQuery(querySQL, withArgumentsIn: nil)
            
            while ((results?.next()) == true) {
                
                productCategoryArray .add(results!.string(forColumn: "productCategory"))
                
            }
            
            
            contactDB?.close()
            
        } else {
            print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
        }
        
        print(productCategoryArray)
        
        return productCategoryArray
        
    }
    
    
    
    
    
    func getSubProductCategory(recordTypeID: String, productCategory:String) -> NSMutableArray {
        
        self .connectDb()
        
        let contactDB = FMDatabase(path: databasePath as String)
        
        let subProductCategoryArray = NSMutableArray()
        
        
        
        if (contactDB!.open()) {
            //            let querySQL = "SELECT * FROM tblProductCatalogue where recordTypeID = '\(recordTypeID)' and productCategory = '\(productCategory)' order by subProductCategory"
            
            let querySQL = "SELECT DISTINCT subProductCategory FROM tblProductCatalogue where recordTypeID = '\(recordTypeID)' order by subProductCategory"
            
            
            let results:FMResultSet? = contactDB?.executeQuery(querySQL, withArgumentsIn: nil)
            
            while ((results?.next()) == true) {
                
                subProductCategoryArray .add(results!.string(forColumn: "subProductCategory"))
                
            }
            
            contactDB?.close()
            
        } else {
            print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
        }
        
        return subProductCategoryArray
        
    }
    
    
    
    
    
    
    func getUpcCode(productCategory: String,subProductCategory: String, recordTypeID: String) -> NSMutableArray {
        
        self .connectDb()
        
        let contactDB = FMDatabase(path: databasePath as String)
        
        mutableArray = NSMutableArray()
        var productURL:String = ""
        var dataSheetURL:String = ""
        var instructionSheetURL:String = ""
        var productVideoURL:String = ""
        var unitlevelUPCCode:String = ""
        var record:String = ""

        if (contactDB!.open()) {
            let querySQL = "SELECT * FROM tblProductCatalogue where productCategory = '\(productCategory)' and subProductCategory = '\(subProductCategory)' and recordTypeID = '\(recordTypeID)'"
            
            let results:FMResultSet? = contactDB?.executeQuery(querySQL, withArgumentsIn: nil)
            
            while ((results?.next()) == true) {
                
                if let value = results!.string(forColumn: "productURL"){
                    productURL = value
                }
                if let value = results!.string(forColumn: "dataSheetURL"){
                    dataSheetURL = value
                }
                if let value = results!.string(forColumn: "instructionSheetURL"){
                    instructionSheetURL = value
                }
                if let value = results!.string(forColumn: "productVideoURL"){
                    productVideoURL = value
                }
                if let value = results!.string(forColumn: "UnitlevelUPCCode"){
                    unitlevelUPCCode = value
                }
                record = "Available"
            }
            
            
            
            mutableArray .add(productURL)
            mutableArray .add(dataSheetURL)
            mutableArray .add(instructionSheetURL)
            mutableArray .add(productVideoURL)
            mutableArray .add(unitlevelUPCCode)
            mutableArray .add(record)

            
            
            contactDB?.close()
            
        } else {
            print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
        }
        
        print(databasePath)
        return mutableArray
        
    }
    
    
    
    
    
    func getUpcCodeFromBarcode(Barcode: String) -> NSMutableArray {
        
        self .connectDb()
        
        let contactDB = FMDatabase(path: databasePath as String)
        
        mutableArray = NSMutableArray()
        var productURL:String = ""
        var dataSheetURL:String = ""
        var instructionSheetURL:String = ""
        var productVideoURL:String = ""
        var productDescription:String = ""
        var record:String = ""

        
        if (contactDB!.open()) {
            let querySQL = "SELECT * FROM tblProductCatalogue WHERE  recordTypeID = '\("3")' and '\(Barcode)' IN (shipperUPCCode, unitLevelUPCCode, upcCode1, upcCode2, upcCode3, GSID)"
            
            let results:FMResultSet? = contactDB?.executeQuery(querySQL, withArgumentsIn: nil)
            
            if ((results?.next()) == true) {
                
                if let value = results!.string(forColumn: "productURL"){
                    productURL = value
                }
                if let value = results!.string(forColumn: "dataSheetURL"){
                    dataSheetURL = value
                }
                if let value = results!.string(forColumn: "instructionSheetURL"){
                    instructionSheetURL = value
                }
                if let value = results!.string(forColumn: "productVideoURL"){
                    productVideoURL = value
                }
                if let value = results!.string(forColumn: "productDesc"){
                    productDescription = value
                }
                
                record = "Available"
                
            }
            
            
            
            mutableArray .add(productURL)
            mutableArray .add(dataSheetURL)
            mutableArray .add(instructionSheetURL)
            mutableArray .add(productVideoURL)
            mutableArray .add(productDescription)
            mutableArray .add(record)

            
            
            contactDB?.close()
            
        } else {
            print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
        }
        
        print(databasePath)
        return mutableArray
        
    }
    
    
    
    func currentTimeInMiliseconds() -> String {
        let currentDate = NSDate()
        let dateFormatter = DateFormatter()
        
        dateFormatter.timeZone = NSTimeZone.default
        dateFormatter.dateFormat = "MM/dd/yy H:m:ss"
        let date =  dateFormatter.date(from: dateFormatter.string(from: currentDate as Date))
        let nowDouble = date!.timeIntervalSince1970
        let currentTime:String = String(Int64(nowDouble*1000))
        
        
        return currentTime
    }
    
    func insertLogData(array: NSArray){
        
        self .connectDb()
        
        //read it
        let contactDB = FMDatabase(path: databasePath as String)
        
        
        
        if !contactDB!.open() {
            print("Error: \(contactDB!.lastErrorMessage())")
        }
            
        else{
            
            
            
            
            for temp in array {
                
                let updatedBy:String = UserDefaults.standard.value(forKey: "userName") as! String
                let updatedDate:String = self.currentTimeInMiliseconds()
                let createdBy:String = ""
                let createdDate:String = self.currentTimeInMiliseconds()
                var recordTypeId:String = ""
                var upcCode:String = ""
                var latitude:Double = 0
                var longtitude:Double = 0
                var projectId:String = ""
                var utilityCompanyId:String = ""
                var installerCompanyId:String = ""
                var seqNumber:String = ""
                var RFIDSerialNumber:String = ""
                var projectName:String = ""
                var logPointDescription:String = ""
                
                
                
                
                if let value = (temp as AnyObject).object(forKey: "recordTypeId") as? String{
                    recordTypeId = value
                }
                if let value = (temp as AnyObject).object(forKey: "upcCode") as? String{
                    upcCode = value
                }
                if let value = (temp as AnyObject).object(forKey: "latitude") as? Double{
                    latitude = value
                }
                if let value = (temp as AnyObject).object(forKey: "longtitude") as? Double{
                    longtitude = value
                }
                if let value = (temp as AnyObject).object(forKey: "projectId") as? String{
                    projectId = value
                }
                if let value = (temp as AnyObject).object(forKey: "utilityCompanyId") as? String{
                    utilityCompanyId = value
                }
                if let value = (temp as AnyObject).object(forKey: "installerCompanyId") as? String{
                    installerCompanyId = value
                }
                if let value = (temp as AnyObject).object(forKey: "seqNumber") as? String{
                    seqNumber = value
                }
                if let value = (temp as AnyObject).object(forKey: "RFIDSerialNumber") as? String{
                    RFIDSerialNumber = value
                }
                if let value = (temp as AnyObject).object(forKey: "projectName") as? String{
                    projectName = value
                }
                if let value = (temp as AnyObject).object(forKey: "logPointDescription") as? String{
                    logPointDescription = value
                }
                
                
                
                let insertSQL = "INSERT or REPLACE INTO tblLogData(recordTypeID, UPCCode, latitude, longtitude, projectID, utilityCompanyID,installerCompanyID, IPAddress, createdBy, createdDate, seqNumber, RFIDSerialNumber, syncStatus,updatedBy,updatedDate,projectName,logPointDescription) VALUES ('\(recordTypeId)', '\(upcCode)', '\(latitude)', '\(longtitude)', '\(projectId)', '\(utilityCompanyId)', '\(installerCompanyId)','','\(createdBy)', '\(createdDate)','\(seqNumber)','\(RFIDSerialNumber)','N','\(updatedBy)','\(updatedDate)','\(projectName)','\(logPointDescription)')"
                
                
                
                let result = contactDB!.executeUpdate(insertSQL, withArgumentsIn: nil)
                
                if !result {
                    print("Error: \(contactDB!.lastErrorMessage())")
                }
                
            }
            
        }
        
        
    }
    
    
    
    
    func getLogData() -> NSMutableArray {
        
        self .connectDb()
        
        mutableArray = NSMutableArray()
        var logDataID:String = ""
        var createdDate:String = ""
        
        
        let contactDB = FMDatabase(path: databasePath as String)
        
        
        if (contactDB!.open()) {
            let querySQL = "SELECT MAX(logDataID),createdDate FROM tblLogData"
            
            let results:FMResultSet? = contactDB?.executeQuery(querySQL, withArgumentsIn: nil)
            
            
            if ((results?.next()) == true) {
                
                logDataID = results!.string(forColumn: "MAX(logDataID)")
                createdDate = results!.string(forColumn: "createdDate")
                
            }
            mutableArray.add(logDataID)
            mutableArray.add(createdDate)
            
            contactDB?.close()
            
        } else {
            print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
        }
        return mutableArray
    }
    
    
    
    
    func insertLogDataDetails(array: NSArray) {
        
        self .connectDb()
        
        //read it
        let contactDB = FMDatabase(path: databasePath as String)
        
        
        if !contactDB!.open() {
            print("Error: \(contactDB!.lastErrorMessage())")
        }
            
        else{
            
            
            
            
            for temp in array {
                
                
                
                let updatedBy:String = UserDefaults.standard.value(forKey: "userName") as! String
                let updatedDate:String = (temp as AnyObject).object(forKey: "createdDate") as! String
                let createdBy:String = ""
                let createdDate:String = (temp as AnyObject).object(forKey: "createdDate") as! String
                var logDataId:String = ""
                var templateTypeId:String = ""
                var labelId:String = ""
                var label:String = ""
                var descriptionId:String = ""
                var description:String = ""
                var dataTypeId:String = ""
                var imagePath:String = ""
                
                
                
                if let value = (temp as AnyObject).object(forKey: "logDataId") as? String{
                    logDataId = value
                }
                if let value = (temp as AnyObject).object(forKey: "templateTypeId") as? String{
                    templateTypeId = value
                }
                if let value = (temp as AnyObject).object(forKey: "labelId") as? String{
                    labelId = value
                }
                if let value = (temp as AnyObject).object(forKey: "label") as? String{
                    label = value
                }
                if let value = (temp as AnyObject).object(forKey: "descriptionId") as? String{
                    descriptionId = value
                }
                if let value = (temp as AnyObject).object(forKey: "description") as? String{
                    description = value
                }
                
                if let value = (temp as AnyObject).object(forKey: "dataTypeId") as? String{
                    dataTypeId = value
                }
                if let value = (temp as AnyObject).object(forKey: "imagePath") as? String{
                    imagePath = value
                }
                
                
                
                
                
                let insertSQL = "INSERT or REPLACE INTO tblLogDataDetail(logDataID, templateTypeId, labelID, label, descriptionID, description, dataTypeID, createdBy, createdDate, syncStatus, imagePath,updatedBy,updatedDate) VALUES ('\(logDataId)', '\(templateTypeId)', '\(labelId)', '\(label)', '\(descriptionId)', '\(description)','\(dataTypeId)','\(createdBy)', '\(createdDate)','N', '\(imagePath)','\(updatedBy)','\(updatedDate)')"
                
                let result = contactDB!.executeUpdate(insertSQL, withArgumentsIn: nil)
                
                if !result {
                    print("Error: \(contactDB!.lastErrorMessage())")
                }
                
            }
            
        }
        
        
        print(databasePath)
    }
    
    
    
    
    
    func getTblLogData() -> [[String: Any]] {
        
        self .connectDb()
        
        
        let contactDB = FMDatabase(path: databasePath as String)
        
        var tblLogData = [[String: Any]]()
        
        
        if (contactDB!.open()) {
            
            let querySQL = "SELECT * FROM tblLogData"
            
            let results:FMResultSet? = contactDB?.executeQuery(querySQL, withArgumentsIn: nil)
            
            
            while ((results?.next()) == true) {
                
                
                
                let logDataEachRow: [String : Any] = ["recordTypeId": results!.string(forColumn: "recordTypeID"),
                                                      "utilityCompanyId": results!.string(forColumn: "utilityCompanyID"),
                                                      "installerCompanyId": results!.string(forColumn: "installerCompanyID"),
                                                      "upcCode": results!.string(forColumn: "UPCCode"),
                                                      "latitude": results!.string(forColumn: "latitude"),
                                                      "longtitude": results!.string(forColumn: "longtitude"),
                                                      "projectId": results!.string(forColumn: "projectID"),
                                                      "seqNumber": results!.string(forColumn: "seqNumber"),
                                                      "rfidSerialNumber": results!.string(forColumn: "RFIDSerialNumber"),
                                                      "createdDate": results!.string(forColumn: "createdDate"),
                                                      "userProfileId": UserDefaults.standard.value(forKey: "userProfileId") as! String,
                                                      "logPointDescription": results!.string(forColumn: "logPointDescription"),
                                                      "deviceId": results!.string(forColumn: "logDataID")] as [String : Any]
                
                
                
                tblLogData .append(logDataEachRow)
                
            }
            
            
            
            
            
            
            
            contactDB?.close()
            
            
        } else {
            print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
        }
        
        
        return tblLogData
        
    }
    
    
    
    
    func getTblLogDataDetails() -> [[String: Any]] {
        
        self .connectDb()
        
        
        let contactDB = FMDatabase(path: databasePath as String)
        
        var tblLogDataDetails = [[String: Any]]()
        
        
        
        if (contactDB!.open()) {
            
            let querySQL = "SELECT * FROM tblLogDataDetail where syncStatus = '\("N")'"
            
            let results:FMResultSet? = contactDB?.executeQuery(querySQL, withArgumentsIn: nil)
            
            
            while ((results?.next()) == true) {
                
                
                
                
                let logDataDetailsEachRow:[String : Any] = ["logDataId": results!.string(forColumn: "logDataID"),
                                                            "labelId": results!.string(forColumn: "labelID"),
                                                            "templateTypeId": results!.string(forColumn: "templateTypeId"),
                                                            "label": results!.string(forColumn: "label"),
                                                            "descriptionId": results!.string(forColumn: "descriptionID"),
                                                            "description": results!.string(forColumn: "description"),
                                                            "createdDate": results!.string(forColumn: "createdDate"),
                                                            "dataTypeId":results!.string(forColumn: "dataTypeID")] as [String : Any]
                
                
                tblLogDataDetails .append(logDataDetailsEachRow)
                
            }
            
            
            
            
            
            
            
            contactDB?.close()
            
            
        } else {
            print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
        }
        
        
        print(tblLogDataDetails)
        
        return tblLogDataDetails
        
    }
    
    
    func deleteLogData(){
        self .connectDb()
        
        //read it
        let contactDB = FMDatabase(path: databasePath as String)
        
        
        if !contactDB!.open() {
            print("Error: \(contactDB!.lastErrorMessage())")
        }
            
        else{
            
            let tableArray:NSArray = ["tblLogData", "tblLogDataDetail"]
            
            
            for i in 0 ..< tableArray.count {
                let sqlStrDelete: String = String(format: "delete from '\(tableArray .object(at: i))'")
                if contactDB!.executeUpdate(sqlStrDelete, withArgumentsIn: nil)
                {
                    print("'\(tableArray .object(at: i))' deleted successfully")
                }
                else {
                    NSLog("'\(tableArray .object(at: i))' NOT deleted successfully, check again.")
                }
            }
            
        }
        
        
        self.deleteImages()
        
        print(databasePath)
    }
    
    
    
    
    
    func deleteImages() {
        let fileManager = FileManager.default
        let documentDirectoryURL =  try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let documentsPath:String = documentDirectoryURL.path
        
        
        
        do {
            
            let filePaths = try fileManager.contentsOfDirectory(atPath: documentsPath)
            
            for filePath in filePaths{
                if(String(filePath.characters.prefix(6)) == "~img~_"){
                    let deletePath:String = String(format:"%@/%@",documentsPath,filePath)
                    try fileManager.removeItem(atPath: deletePath)
                }
            }
        } catch let error as NSError {
            print("Could not clear temp folder: \(error.debugDescription)")
        }
    }
    
    
    
    
    //    func updateSyncStatus(recordTypeId:String) {
    //
    //        self .connectDb()
    //
    //
    //        //read it
    //        let contactDB = FMDatabase(path: databasePath as String)
    //
    //
    //        if !contactDB!.open() {
    //            print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
    //        }
    //
    //        else{
    //
    //
    //            var sqlStrUpdate: String = String(format: "update tblLogData Set syncStatus='\("C")' where syncStatus= '\("N")' and recordTypeId = '\(recordTypeId)'")
    //
    //            if (contactDB!.executeUpdate(sqlStrUpdate, withArgumentsIn: nil))
    //            {
    //                print("tblLogData updated successfully")
    //            }
    //            else {
    //                NSLog("tblLogData NOT updated successfully, check again.")
    //            }
    //
    //
    //
    //
    //            sqlStrUpdate = String(format: "update tblLogDataDetail Set syncStatus='\("C")' where syncStatus= '\("N")'")
    //
    //            if (contactDB!.executeUpdate(sqlStrUpdate, withArgumentsIn: nil))
    //            {
    //                print("tblLogDataDetail updated successfully")
    //            }
    //            else {
    //                NSLog("tblLogDataDetail NOT updated successfully, check again.")
    //            }
    //
    //
    //
    //
    //
    //        }
    //
    //    }
    //
    
    
    
    
    
    func getUserProfile(columnName:String) -> String {
        
        self .connectDb()
        
        
        var value:String = ""
        
        let contactDB = FMDatabase(path: databasePath as String)
        
        
        if (contactDB!.open()) {
            let querySQL = "SELECT * FROM tblUserProfile"
            
            let results:FMResultSet? = contactDB?.executeQuery(querySQL, withArgumentsIn: nil)
            
            
            if ((results?.next()) == true) {
                if let notNullValue = results!.string(forColumn: columnName){
                    value = notNullValue
                }
            }
            contactDB?.close()
            
        } else {
            print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
        }
        
        return value
        
    }
    
    
    
    
    
    
    
    
    
    
    
    func getimagePathDetails(recordTypeId:String) -> NSMutableArray {
        
        self .connectDb()
        
        let contactDB = FMDatabase(path: databasePath as String)
        
        mutableArray = NSMutableArray()
        let imagePathArray = NSMutableArray()
        let logDataDetailIDArray = NSMutableArray()
        
        print(databasePath)
        
        
        if (contactDB!.open()) {
            let querySQL = "SELECT * FROM tblLogDataDetail where imagePath != '\("")' and syncStatus= '\("N")'"
            
            
            let results:FMResultSet? = contactDB?.executeQuery(querySQL, withArgumentsIn: nil)
            
            while ((results?.next()) == true) {
                
                imagePathArray .add(results!.string(forColumn: "imagePath"))
                logDataDetailIDArray .add(results!.string(forColumn: "logDataDetailID"))
                
            }
            
            mutableArray .add(imagePathArray)
            mutableArray .add(logDataDetailIDArray)
            
            
            contactDB?.close()
            
        } else {
            print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
        }
        
        print(databasePath)
        
        
        
        return mutableArray
        
    }
    
    
    
    func updateDescriptionLogDataDetail(description:String, logDataDetailID:String) {
        
        self .connectDb()
        
        
        //read it
        let contactDB = FMDatabase(path: databasePath as String)
        
        
        if !contactDB!.open() {
            print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
        }
            
        else{
            
            
            let sqlStrUpdate: String = String(format: "update tblLogDataDetail Set description ='\(description)' where logDataDetailID = '\(logDataDetailID)'")
            
            if (contactDB!.executeUpdate(sqlStrUpdate, withArgumentsIn: nil))
            {
                print("tblLogDataDetail updated successfully")
            }
            else {
                NSLog("tblLogDataDetail NOT updated successfully, check again.")
            }
        }
        
    }
    
    
    
    func getLastSyncTimeSettings() -> String {
        
        self .connectDb()
        
        let contactDB = FMDatabase(path: databasePath as String)
        
        var lastSyncTime:String = ""
        
        
        if (contactDB!.open()) {
            let querySQL = "SELECT * FROM tblSettings"
            
            let results:FMResultSet? = contactDB?.executeQuery(querySQL, withArgumentsIn: nil)
            
            if ((results?.next()) == true) {
                
                if let value = results!.string(forColumn: "lastSyncTime"){
                    lastSyncTime = value
                }
            }
            
            contactDB?.close()
            
            
        } else {
            print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
        }
        
        print(databasePath)
        return lastSyncTime
        
    }
    
    
    
    func updateLastSyncTimeSetting(lastSyncTime:String) {
        
        self .connectDb()
        //read it
        let contactDB = FMDatabase(path: databasePath as String)
        
        
        if !contactDB!.open() {
            print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
        }
            
        else{
            
            
            let sqlStrUpdate: String = String(format: "update tblSettings Set lastSyncTime ='\(lastSyncTime)'")
            
            if (contactDB!.executeUpdate(sqlStrUpdate, withArgumentsIn: nil))
            {
                print("tblSettings updated successfully")
            }
            else {
                NSLog("tblSettings NOT updated successfully, check again.")
            }
        }
        
    }
    
    func updateGlossaryLangaugeSetting(languageId:String, languageName:String) {
        
        self .connectDb()
        
        
        //read it
        let contactDB = FMDatabase(path: databasePath as String)
        
        
        if !contactDB!.open() {
            print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
        }
            
        else{
            
            
            let sqlStrUpdate: String = String(format: "update tblSettings Set GlossaryLanguageId ='\(languageId)',  GlossaryLanguageName ='\(languageName)'")
            
            if (contactDB!.executeUpdate(sqlStrUpdate, withArgumentsIn: nil))
            {
                print("tblSettings updated successfully")
            }
            else {
                NSLog("tblSettings NOT updated successfully, check again.")
            }
        }
        
    }
    
    
    func updateAppLanguageSetting(languageName:String) {
        
        self .connectDb()
        
        
        //read it
        let contactDB = FMDatabase(path: databasePath as String)
        
        if !contactDB!.open() {
            print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
        }
            
        else{
            
            let sqlStrUpdate: String = String(format: "update tblSettings Set AppLanguageName ='\(languageName)'")
            
            if (contactDB!.executeUpdate(sqlStrUpdate, withArgumentsIn: nil))
            {
                print("tblSettings updated successfully")
            }
            else {
                NSLog("tblSettings NOT updated successfully, check again.")
            }
        }
        
    }
    
    
    
    
    
    func getGlossaryLanguageSettings() -> NSArray {
        
        self .connectDb()
        mutableArray = NSMutableArray()
        
        let contactDB = FMDatabase(path: databasePath as String)
        
        var languageId:String = ""
        var languageName:String = ""
        
        
        if (contactDB!.open()) {
            let querySQL = "SELECT * FROM tblSettings"
            
            let results:FMResultSet? = contactDB?.executeQuery(querySQL, withArgumentsIn: nil)
            
            if ((results?.next()) == true) {
                
                if let value = results!.string(forColumn: "GlossaryLanguageId"){
                    languageId = value
                }
                else
                {
                    languageId = "1"
                }
                
                
                if let value = results!.string(forColumn: "GlossaryLanguageName"){
                    languageName = value
                }
                else{
                    languageName = "English"
                }
            }
            
            
            
            
            if(languageId != "1"){
                let querySQL4 = "SELECT * FROM tblDescriptionTranslation where languageID = '\(languageId)'"
                let results4:FMResultSet? = contactDB?.executeQuery(querySQL4, withArgumentsIn: nil)
                if ((results4?.next()) == false) {
                    languageId = "1"
                    languageName = "English"
                }
            }
            
            
            
            mutableArray .add(languageId)
            mutableArray .add(languageName)
            
            contactDB?.close()
            
            
        } else {
            print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
        }
        
        print(databasePath)
        return mutableArray as NSArray
        
    }
    
    
    func getUtilityCompanyType(utilityCompanyTypeDesc:String) -> Int {
        
        self .connectDb()
        
        let contactDB = FMDatabase(path: databasePath as String)
        
        var utilityTypeID:Int = 0
        
        
        if (contactDB!.open()) {
            let querySQL = "SELECT * FROM tblUtilityCompanyType where utilityCompanyTypeDesc = '\(utilityCompanyTypeDesc)'"
            
            let results:FMResultSet? = contactDB?.executeQuery(querySQL, withArgumentsIn: nil)
            
            if ((results?.next()) == true) {
                
                utilityTypeID = Int(results!.int(forColumn: "utilityCompanyTypeID"))
                
            }
            
            contactDB?.close()
            
            
        } else {
            print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
        }
        
        return utilityTypeID
        
    }
    
    
    
    
    
    //
    //    func getLatLong() -> NSMutableArray {
    //
    //        self .connectDb()
    //
    //        mutableArray = NSMutableArray()
    //        let latArray = NSMutableArray()
    //        let longArray = NSMutableArray()
    //        let logDataIDArray = NSMutableArray()
    //
    //
    //        let contactDB = FMDatabase(path: databasePath as String)
    //
    //
    //        if (contactDB!.open()) {
    //            let querySQL = "SELECT * FROM tblLogData"
    //
    //            let results:FMResultSet? = contactDB?.executeQuery(querySQL, withArgumentsIn: nil)
    //
    //
    //            while ((results?.next()) == true) {
    //
    //                latArray .add(results!.string(forColumn: "latitude"))
    //                longArray .add(results!.string(forColumn: "longtitude"))
    //                logDataIDArray .add(results!.string(forColumn: "logDataID"))
    //
    //            }
    //            mutableArray.add(latArray)
    //            mutableArray.add(longArray)
    //            mutableArray.add(logDataIDArray)
    //
    //            contactDB?.close()
    //
    //        } else {
    //            print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
    //        }
    //        return mutableArray
    //    }
    //
    
    
    
    
    func getTblLogData(searchText:String, searchType:String, latitude:Double, longitude:Double) -> (local: NSMutableArray, api: [[String: Any]]) {
        
        self .connectDb()
        
        
        var value1:String = searchText
        
        let tblLogData = NSMutableArray()
        var tblLogDataApiFormat =  [[String: Any]]()
        
        
        
        let contactDB = FMDatabase(path: databasePath as String)
        
        
        var columnName1:String = "projectName"
        
        if(searchType == "Project Name"){
            columnName1 = "projectName"
        }
        else if(searchType == "UPC Code"){
            columnName1 = "UPCCode"
        }
        else if(searchType == "Product Description"){
            columnName1 = "productDesc"
        }
        else if(searchType == "Record Type"){
            columnName1 = "recordTypeID"
            
            let rfid = "RFID Program"
            let ems = "EMS Passive"
            let cable = "Cable Accessories"
            
            
            if rfid.lowercased().contains(value1.lowercased()) {
                value1 = "1"
            }
            else if ems.lowercased().contains(value1.lowercased()) {
                value1 = "2"
            }
            else if cable.lowercased().contains(value1.lowercased()) {
                value1 = "3"
            }
            
        }
        else if(searchType == "Address"){
            columnName1 = "Address"
        }
        
        
        
        
        let canlookuputilitycompanyData:String = self.getUserProfile(columnName: "canlookuputilitycompanyData")
        let canlookupinstallercompanyData:String = self.getUserProfile(columnName: "canlookupinstallercompanyData")
        let Canlookupowndata:String = self.getUserProfile(columnName: "Canlookupowndata")
        
        
        var columnName2:String = ""
        var value2:String = ""
        
        
        if canlookuputilitycompanyData == "Y" {
            columnName2 = "utilityCompanyID"
            value2 = self.getUserProfile(columnName: "utilityCompanyID")
        }
        else if canlookupinstallercompanyData == "Y" {
            columnName2 = "installerCompanyID"
            value2 = self.getUserProfile(columnName: "installerCompanyID")
        }
        else if Canlookupowndata == "Y" {
            columnName2 = "updatedBy"
            value2 = self.getUserProfile(columnName: "userName")
        }
        
        
        
        
        
        
        if (contactDB!.open()) {
            
            var querySQL = ""
            
            
            if(searchType == "Product Description"){
                querySQL = "Select * from tblLogData AS log INNER JOIN tblProductCatalogue AS cat ON  (log.UPCCode = cat.unitLevelUPCCode and cat.unitLevelUPCCode != '') or (log.UPCCode = shipperUPCCode and shipperUPCCode != '') or (log.UPCCode = cat.upcCode1 and cat.upcCode1 != '') or (log.UPCCode = cat.upcCode2 and cat.upcCode2 != '') or (log.UPCCode = cat.upcCode3 and cat.upcCode3 != '') or (log.UPCCode = cat.GSID and cat.GSID != '')  where (productDesc LIKE '%\(searchText)%')"
                
                
                
                
            }
            else  if(searchType == "Address"){
                querySQL = "Select * from tblLogData where latitude != '' and longtitude != ''"
            }
            else{
                
                querySQL = "SELECT * FROM tblLogData where (\(columnName1) LIKE '%\(value1)%') and \(columnName2) = '\(value2)'"
            }
            
            let results:FMResultSet? = contactDB?.executeQuery(querySQL, withArgumentsIn: nil)
            
            
            while ((results?.next()) == true) {
                
                
                
                let recordTypeId:Int = Int(results!.string(forColumn: "recordTypeId"))!
                let logDataId:Int = Int(results!.string(forColumn: "logDataID"))!
                let updatedDate:Int = Int(results!.string(forColumn: "updatedDate"))!
                
                
                
                var recordType:String = ""
                if(recordTypeId == 1){
                    recordType = "RFID Program"
                }
                else if(recordTypeId == 2){
                    recordType = "EMS Passive"
                }
                else{
                    recordType = "Cable Accessories"
                }
                
                
                var success:Bool = true
                
                
                
                
                if(searchType == "Address"){
                    
                    
                    let latitudeFromDB:Double = results!.double(forColumn: "latitude")
                    let longtitudeFromDB:Double = results!.double(forColumn: "longtitude")
                    
                    
                    let coordinate₀ = CLLocation(latitude: latitude, longitude: longitude)
                    let coordinate₁ = CLLocation(latitude: latitudeFromDB, longitude: longtitudeFromDB)
                    
                    let distanceInMeters = coordinate₀.distance(from: coordinate₁) // result is in meters
                    let distancefor50Miles = 1609.34 * 50
                    
                    print(distanceInMeters)
                    
                    if(distanceInMeters > distancefor50Miles)
                    {
                        success = false
                    }
                }
                
                
                if success {
                    
                    
                    let logDataEachRow: [String : Any] = ["recordTypeId": recordTypeId,
                                                          "projectName": results!.string(forColumn: "projectName"),
                                                          "upcCode": results!.string(forColumn: "UPCCode"),
                                                          "rfidSerialNumber": results!.string(forColumn: "RFIDSerialNumber"),
                                                          "latitude": results!.string(forColumn: "latitude"),
                                                          "longtitude": results!.string(forColumn: "longtitude"),
                                                          "updatedBy": results!.string(forColumn: "updatedBy"),
                                                          "updatedDate": updatedDate,
                                                          "logDataId": logDataId] as [String : Any]
                    
                    
                    tblLogData .add(logDataEachRow)
                    
                    
                    
                    let logDataforApi: [String : Any] = ["recordTypeId": results!.string(forColumn: "recordTypeID"),
                                                         "utilityCompanyId": results!.string(forColumn: "utilityCompanyID"),
                                                         "installerCompanyId": results!.string(forColumn: "installerCompanyID"),
                                                         "upcCode": results!.string(forColumn: "UPCCode"),
                                                         "latitude": results!.string(forColumn: "latitude"),
                                                         "longtitude": results!.string(forColumn: "longtitude"),
                                                         "projectId": results!.string(forColumn: "projectID"),
                                                         "seqNumber": results!.string(forColumn: "seqNumber"),
                                                         "rfidSerialNumber": results!.string(forColumn: "RFIDSerialNumber"),
                                                         "createdDate": results!.string(forColumn: "createdDate"),
                                                         "userProfileId": UserDefaults.standard.value(forKey: "userProfileId") as! String,
                                                         "logPointDescription": results!.string(forColumn: "logPointDescription"),
                                                         "deviceId": results!.string(forColumn: "logDataID"),
                                                         "recordType": recordType,
                                                         "projectName": results!.string(forColumn: "projectName"),
                                                         "updatedDate": results!.string(forColumn: "updatedDate"),
                                                         "updatedBy": results!.string(forColumn: "updatedBy")] as [String : Any]
                    
                    
                    
                    
                    tblLogDataApiFormat .append(logDataforApi)
                }
                
                
            }
            
            
            
            
            
            
            
            contactDB?.close()
            
            
            
        } else {
            print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
        }
        
        
        return (tblLogData, tblLogDataApiFormat)
        
    }
    
    
    
    func getTblLogDataDetails(logDataId:Int) -> NSMutableArray {
        
        self .connectDb()
        
        
        let contactDB = FMDatabase(path: databasePath as String)
        
        let tblLogDataDetails = NSMutableArray()
        
        
        
        if (contactDB!.open()) {
            
            let querySQL = "SELECT * FROM tblLogDataDetail where logDataID = '\(logDataId)'"
            
            let results:FMResultSet? = contactDB?.executeQuery(querySQL, withArgumentsIn: nil)
            
            
            while ((results?.next()) == true) {
                
                let templateTypeId:Int = Int(results!.string(forColumn: "templateTypeId"))!
                
                var dataTypeID:Int = 0
                if let value = results!.string(forColumn: "dataTypeID"){
                    if value != ""{
                        dataTypeID = Int(value)!
                    }
                }
                
                let logDataDetailsEachRow:[String : Any] = ["templateTypeId": templateTypeId,
                                                            "label": results!.string(forColumn: "label"),
                                                            "description": results!.string(forColumn: "description"),
                                                            "dataTypeId":dataTypeID,
                                                            "imagePath":results!.string(forColumn: "imagePath")] as [String : Any]
                
                
                
                
                
                
                
                tblLogDataDetails .add(logDataDetailsEachRow)
                
            }
            
            contactDB?.close()
            
            
        } else {
            print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
        }
        
        
        print(tblLogDataDetails)
        
        return tblLogDataDetails
        
    }
    
    
    func exportLogDataDetails(logData:[[String: Any]]) -> (imageArray: NSArray, api: [[String: Any]]) {
        
        self .connectDb()
        
        
        
        
        print(logData)
        
        let contactDB = FMDatabase(path: databasePath as String)
        
        var tblLogDataDetails = [[String: Any]]()
        mutableArray = NSMutableArray()
        
        
        if (contactDB!.open()) {
            
            
            
            
            
            for temp in logData {
                
                let logDataID:String = (temp as AnyObject).object(forKey: "deviceId") as! String
                
                let querySQL = "SELECT * FROM tblLogDataDetail where logDataID = '\(logDataID)'"
                
                let results:FMResultSet? = contactDB?.executeQuery(querySQL, withArgumentsIn: nil)
                
                
                while ((results?.next()) == true) {
                    
                    
                    
                    
                    let logDataDetailsEachRow:[String : Any] = ["logDataId": results!.string(forColumn: "logDataID"),
                                                                "labelId": results!.string(forColumn: "labelID"),
                                                                "templateTypeId": results!.string(forColumn: "templateTypeId"),
                                                                "label": results!.string(forColumn: "label"),
                                                                "descriptionId": results!.string(forColumn: "descriptionID"),
                                                                "description": results!.string(forColumn: "description"),
                                                                "createdDate": results!.string(forColumn: "createdDate"),
                                                                "dataTypeId":results!.string(forColumn: "dataTypeID")] as [String : Any]
                    
                    
                    
                    tblLogDataDetails .append(logDataDetailsEachRow)
                    
                    let imagePath:String = results!.string(forColumn: "imagePath")
                    if imagePath != "" {
                        mutableArray.add(imagePath)
                    }
                    
                    
                }
                
                
                
                
            }
            
            
            
            
            contactDB?.close()
            
            
        } else {
            print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
        }
        
        
        print(tblLogDataDetails)
        
        return (mutableArray, tblLogDataDetails)
        
    }
    
    
    func getUtilityCompany(columnName:String) -> String {
        
        self .connectDb()
        
        
        var value:String = ""
        
        let contactDB = FMDatabase(path: databasePath as String)
        
        
        if (contactDB!.open()) {
            let querySQL = "SELECT * FROM tblUtilityCompany"
            
            let results:FMResultSet? = contactDB?.executeQuery(querySQL, withArgumentsIn: nil)
            
            
            if ((results?.next()) == true) {
                if let notNullValue = results!.string(forColumn: columnName){
                    value = notNullValue
                }
            }
            contactDB?.close()
            
        } else {
            print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
        }
        
        return value
        
    }
    
    func deleteLogData(logData:[[String: Any]]) {
        self .connectDb()
        
        //read it
        let contactDB = FMDatabase(path: databasePath as String)
        
        
        if !contactDB!.open() {
            print("Error: \(contactDB!.lastErrorMessage())")
        }
            
        else{
            
            print(logData)
            
            for temp in logData {
                let logDataID:String = (temp as AnyObject).object(forKey: "logDataId") as! String
                
                var sqlStrDelete: String = String(format: "delete from tblLogData where logDataID = '\(logDataID)'")
                if contactDB!.executeUpdate(sqlStrDelete, withArgumentsIn: nil)
                {
                    print("tblLogData deleted successfully")
                }
                else {
                    NSLog("tblLogData NOT deleted successfully, check again.")
                }
                
                
                sqlStrDelete = String(format: "delete from tblLogDataDetail where logDataID = '\(logDataID)'")
                if contactDB!.executeUpdate(sqlStrDelete, withArgumentsIn: nil)
                {
                    print("tblLogDataDetail deleted successfully")
                }
                else {
                    NSLog("tblLogDataDetail NOT deleted successfully, check again.")
                }
                
            }
            
        }
        
        
        
        print(databasePath)
    }
    
    
    
    func updateStorage(storage:String) {
        
        self .connectDb()
        //read it
        let contactDB = FMDatabase(path: databasePath as String)
        
        
        if !contactDB!.open() {
            print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
        }
            
        else{
            let sqlStrUpdate: String = String(format: "update tblSettings Set Storage ='\(storage)'")
            
            if (contactDB!.executeUpdate(sqlStrUpdate, withArgumentsIn: nil))
            {
                print("tblSettings updated successfully")
            }
            else {
                NSLog("tblSettings NOT updated successfully, check again.")
            }
        }
        
    }
    
    
    
    func getSettings(columnName:String) -> String {
        
        self .connectDb()
        mutableArray = NSMutableArray()
        
        let contactDB = FMDatabase(path: databasePath as String)
        
        var storage:String = ""
        
        if (contactDB!.open()) {
            let querySQL = "SELECT * FROM tblSettings"
            
            let results:FMResultSet? = contactDB?.executeQuery(querySQL, withArgumentsIn: nil)
            
            if ((results?.next()) == true) {
                if let value = results!.string(forColumn: columnName){
                    storage = value
                }
            }
            
            
            
            let  canStoreDataToCloud:String = self.getUserProfile(columnName: "canStoreDataToCloud")
            let utilityCompanyVerifiedState:String = self.getUtilityCompany(columnName: "verified")
            if canStoreDataToCloud == "Y" && utilityCompanyVerifiedState == "Y" && storage != "Local Storage"{
                storage = "Cloud Storage"
            }
            else{
                storage = "Local Storage"
            }
            
            
  
            
            contactDB?.close()
            
        } else {
            print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
        }
        
        return storage
        
    }
    
    
    
    func getLanguageSettings() -> NSArray {
        self .connectDb()
        mutableArray = NSMutableArray()
        
        let contactDB = FMDatabase(path: databasePath as String)
        
        
        
        if (contactDB!.open()) {
            let querySQL = "SELECT * FROM tblSettings"
            
            let results:FMResultSet? = contactDB?.executeQuery(querySQL, withArgumentsIn: nil)
            
            if ((results?.next()) == true) {
                
                
                let AppLanguageName:String = results!.string(forColumn: "AppLanguageName")
                let GlossaryLanguageName:String = results!.string(forColumn: "GlossaryLanguageName")
                mutableArray = [AppLanguageName,GlossaryLanguageName]
                
            }
            contactDB?.close()
        }
        return mutableArray
    }
    
    
    func deleteTemplateDetails(templateID:String) {
        self .connectDb()
        
        //read it
        let contactDB = FMDatabase(path: databasePath as String)
        
        
        if !contactDB!.open() {
            print("Error: \(contactDB!.lastErrorMessage())")
        }
            
        else{
                        
            let sqlStrDelete: String = String(format: "delete from tblTemplateDetails where templateID = '\(templateID)'")
            if contactDB!.executeUpdate(sqlStrDelete, withArgumentsIn: nil)
            {
                print("tblTemplateDetails deleted successfully")
            }
            else {
                NSLog("tblTemplateDetails NOT deleted successfully, check again.")
            }
        }
        
        print(databasePath)
    }
    
    
    func updatePrimaryFunction(functionTypeID:String) {
        
        self .connectDb()
        
        
        //read it
        let contactDB = FMDatabase(path: databasePath as String)
        
        
        if !contactDB!.open() {
            print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
        }
            
        else{
            
            
            let sqlStrUpdate: String = String(format: "update tblUserProfile Set functionTypeID ='\(functionTypeID)'")
            
            if (contactDB!.executeUpdate(sqlStrUpdate, withArgumentsIn: nil))
            {
                print("tblUserProfile updated successfully")
            }
            else {
                NSLog("tblUserProfile NOT updated successfully, check again.")
            }
        }
        
    }
    
    
    
}

