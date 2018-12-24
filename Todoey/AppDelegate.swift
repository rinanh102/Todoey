//
//  AppDelegate.swift
//  Todoey
//
//  Created by henry on 06/11/2018.
//  Copyright © 2018 HenryNguyen. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Create a brand new Realm
        //Realm initialization
        do{
            _ = try Realm()
        }catch{
            print("ERROR with initializing new Realm: \(error)")
        }
        return true
    }

}

