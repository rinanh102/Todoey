//
//  Data.swift
//  Todoey
//
//  Created by henry on 23/12/2018.
//  Copyright © 2018 HenryNguyen. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object{
    // dynamic that means, the data is gonna update when users modify it at runtime
    // @objc means that dynamic from Objective-C
    @objc dynamic var name : String = ""
    @objc dynamic var age : Int = 0
}
