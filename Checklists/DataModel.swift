//
//  DataModel.swift
//  Checklists
//
//  Created by Leonel Menezes on 18/05/17.
//  Copyright © 2017 BEPID. All rights reserved.
//

import Foundation

class DataModel {
    var lists = [Checklist]()
    var indexOfSelectedChecklist : Int{
        get{
            return UserDefaults.standard.integer(forKey: "ChecklistIndex")
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    init() {
        loadChecklists()
        registerDefaults()
        handleFirstTime()
    }
    
    
    func documentsDirectory() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0]
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklist.plist")
    }
    
    func saveChecklists(){
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        
        archiver.encode(lists, forKey: "Checklists")
        
        archiver.finishEncoding()
        
        data.write(to: dataFilePath(), atomically: true)
    }
    
    func loadChecklists(){
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path){
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            
            lists = unarchiver.decodeObject(forKey: "Checklists") as! [Checklist]
            
            unarchiver.finishDecoding()
            sortChecklists()
        }
        
    }
    
    func registerDefaults(){
        
        let dictionary : [String : Any] = ["ChecklistIndex" : -1,
                                           "FirstTime": true]
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    func handleFirstTime() {
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: "FirstTime")
        
        if firstTime {
            let checklist = Checklist(name: "List")
            lists.append(checklist)
            
            indexOfSelectedChecklist = 0
            userDefaults.set(false, forKey: "FirstTime")
            userDefaults.synchronize()
        }
    }
    
    
    func sortChecklists(){
        lists.sort(by: {checklist1, checklist2 in
            return checklist1.name.localizedStandardCompare(checklist2.name) == .orderedAscending
        })
    }
    
}
