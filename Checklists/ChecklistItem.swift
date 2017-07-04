//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Leonel Menezes on 03/05/17.
//  Copyright © 2017 BEPID. All rights reserved.
//

import Foundation


class ChecklistItem: NSObject, NSCoding{
    var text = ""
    var checked = false
    func toggleChecked(){
        checked = !checked
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: "Text")
        aCoder.encode(checked, forKey: "Checked")
    }
    
    required init?(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObject(forKey: "Text") as! String
        checked = aDecoder.decodeBool(forKey: "Checked")
        super.init()
    }
    
    override init(){
        super.init()
    }
}
