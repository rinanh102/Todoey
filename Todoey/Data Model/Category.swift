//
//  Category.swift
//  Todoey
//
//  Created by henry on 23/12/2018.
//  Copyright © 2018 HenryNguyen. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name : String = ""
    // Create an empty List (likes Array)
    // indise each Category, this thing called item, it will point to list of item object
    // we have foward relationship, each Category has a list of items
    let items = List<Item>()
}
