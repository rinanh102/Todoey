//
//  Item.swift
//  Todoey
//
//  Created by henry on 23/12/2018.
//  Copyright © 2018 HenryNguyen. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object{
    @objc dynamic var title :  String = ""
    @objc dynamic var done : Bool = false
    // LinkingObjects only define the inverse relationship of Items
    //Each Items have a parentCategory, it has type - Category, and come form property called "items"
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
