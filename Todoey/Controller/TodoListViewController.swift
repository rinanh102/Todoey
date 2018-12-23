//
//  ViewController.swift
//  Todoey
//
//  Created by henry on 06/11/2018.
//  Copyright © 2018 HenryNguyen. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    let realm = try! Realm()
    
    var todoItems : Results<Item>?
    // ditSet is gonna happen as soon as "selectedCategory has the value"
    var selectedCategory : Category?{
        didSet{
            // when we ccall loadItems(), we already have some value for "selectedCategory"
             // call the func without any parameters
            loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
 
//    print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)) // print the path of data
    }
    
    //MARK: Table View DataSoure Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        if let item = todoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            
            //Ternary operator -->
            // value = condition ? trueValue : falseValue
            cell.accessoryType = item.done ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No Item "
        }
       
        return cell
    }
    
    //MARK: TableView Delegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true) // make a flash effect when ppl tap on the cell
        
        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write {
                    realm.delete(item)
//                    item.done = !item.done
                }
            }catch{
                print("ERROR done status: \(error)")
            }
           tableView.reloadData()
        }
    }
    
    //MARK: Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField() // create a LOCAL variable within IBAction
        
        let alert:UIAlertController = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: UIAlertController.Style.alert)
        
        let action:UIAlertAction = UIAlertAction(title: "Add Item", style: UIAlertAction.Style.default) { (action) in
            //What happen when user click on "Add Item" button
            
            //create a new object of type item
            if let currentItem = self.selectedCategory{
                // save Items
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentItem.items.append(newItem)
                    }
                }catch{
                    print("ERROR saving Items: \(error)")
                }
            }
          self.tableView.reloadData()
           	
        } //--------
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField  //assign the LOCAL to a variable in closure
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    //MARK: Model Manupulation Method
    
    
//Provide the default value In case when we retrive the func bbut dont pass anything (Item.fetchRequest())
  //   set 'nil' is the default value for predicate --> use ? to wrap value
    func loadItems(){

        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }
}

//MARK: - Search bar Method
extension TodoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(searchBar.text!)
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
        
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }
}


