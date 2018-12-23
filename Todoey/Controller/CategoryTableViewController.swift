//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by henry on 09/12/2018.
//  Copyright © 2018 HenryNguyen. All rights reserved.
//

import UIKit
import RealmSwift
class CategoryTableViewController: UITableViewController {

    let realm = try! Realm()
    
    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        loadCategories()
        print("Category: \(categoryArray)")
    }

    //MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
        cell.accessoryType = .disclosureIndicator
        return cell
    }
     //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(categoryArray[indexPath.row])
        
//        tableView.deselectRow(at: indexPath, animated: true)
        
       performSegue(withIdentifier: "GoToItem", sender: self)
            
        }
    // prepare just before performSegue above
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // new constant to store the reference to the desination ViewController
        //if we have more than one seque, we have to use if statement to check if seque have "withIdentifier"
        let desinationVC = segue.destination as! TodoListViewController
        
        // if indexPath not nil
        if let indexPath = tableView.indexPathForSelectedRow{
            desinationVC.selectedCategory = categoryArray[indexPath.row]
        }
        
    }
    
    //MARK: - TableView Manipulation Methods
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
    
//    func loadCategories(){
//        
//        let request : NSFetchRequest<Category> = Category.fetchRequest()
//        
//        do{
//           categoryArray = try context.fetch(request)
//        }catch{
//            print("Error loading Categories: \(error)")
//        }
//    }

    //MARK: - Add New Items
    @IBAction func btnAddButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert:UIAlertController = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action:UIAlertAction = UIAlertAction(title: "Add", style: .default) { (action) in
            // What happens when click the button "Add"
            let newCategory = Category()
            newCategory.name = textField.text!
            self.categoryArray.append(newCategory)
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
