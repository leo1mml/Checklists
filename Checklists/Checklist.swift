//
//  Checklist.swift
//  Checklists
//
//  Created by Leonel Menezes on 12/05/17.
//  Copyright © 2017 BEPID. All rights reserved.
//

import UIKit

class Checklist: NSObject, NSCoding {
    
    var name = ""
    var iconName : String
    var items = [ChecklistItem]()
    
    init(name: String, iconName : String) {
        self.name = name
        self.iconName = iconName
        self.iconName = "Appointments"
        super.init()
    }
    
    convenience init(name: String) {
        self.init(name: name, iconName: "No Icon")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "Name") as! String
        self.items = aDecoder.decodeObject(forKey: "Items") as! [ChecklistItem]
        self.iconName = aDecoder.decodeObject(forKey: "IconName") as! String
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "Name")
        aCoder.encode(self.items, forKey: "Items")
        aCoder.encode(self.iconName, forKey: "IconName")
    }
    
    func countUncheckedItems() -> Int{
        var count = 0
        for item in items where !item.checked {
            count += 1
        }
        return count
    }
    
}
