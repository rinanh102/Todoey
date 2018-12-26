//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by henry on 09/12/2018.
//  Copyright © 2018 HenryNguyen. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class CategoryTableViewController: SwipeTableViewController {
    //initialize a new access to Realm Database
    let realm = try! Realm()
    
    // Results Object auto-update new object
    // changed our categories from an array of category items to this new collection type which is a collection of results that our category objects.
    //And this is an optional so that we can be safe.
    var categories : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
//        print(Realm.Configuration.defaultConfiguration.fileURL)
        loadCategories()
    }

    //MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        // ---- TWO way to deal with 
//        if let category = categories?[indexPath.row]{
//            cell.textLabel?.text = category.name
//
//            cell.backgroundColor = UIColor(hexString: category.hexColor )
//        }
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Caregory Added Yet"
        
        cell.backgroundColor = UIColor(hexString: categories?[indexPath.row].hexColor ?? "89DBFE")
        
        cell.accessoryType = .disclosureIndicator
        
        
        return cell
    }
     //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(categories?[indexPath.row] ?? "No Caregory")
        
       performSegue(withIdentifier: "GoToItem", sender: self)
            
        }
    // prepare just before performSegue above
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // new constant to store the reference to the desination ViewController
        //if we have more than one seque, we have to use if statement to check if seque have "withIdentifier"
        let desinationVC = segue.destination as! TodoListViewController
        
        // if indexPath not nil
        if let indexPath = tableView.indexPathForSelectedRow{
            desinationVC.selectedCategory = categories?[indexPath.row]
        }
        
    }
    
    //MARK: - TableView Manipulation Methods
    // persist data in Realmk;,,,m;;@@n
    func save(category: Category){
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("Error Saving Category message: \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories(){
        //we set that property categories to look inside our realm and fetch all of the objects that belong to the category data type.
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    //MARK: - Delete Data from Swipe
    override func updateData(at indexPath: IndexPath) {
//        super.updateData(at: indexPath)
            if let categoryIsSelected = self.categories?[indexPath.row]{
                do{
                    try self.realm.write {
                        self.realm.delete(categoryIsSelected)
                    }
                }catch{
                    print("ERROR deleting Category: \(error)")
                }
            }
    }

    //MARK: - Add New Category
    @IBAction func btnAddButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert:UIAlertController = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action:UIAlertAction = UIAlertAction(title: "Add", style: .default) { (action) in
            // What happens when click the button "Add"
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.hexColor = UIColor.randomFlat.hexValue()
          
            self.save(category: newCategory)
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new category"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}

