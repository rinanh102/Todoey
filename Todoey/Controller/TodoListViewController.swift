//
//  ViewController.swift
//  Todoey
//
//  Created by henry on 06/11/2018.
//  Copyright © 2018 HenryNguyen. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController{

    var itemArray = [Item]() // an array of item Objects
    let defaults = UserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // NOTICE: look back Quiz App for MVC pattern
       let newItem1 = Item() //Use Item class, so newItem is a new object of Item class
        newItem1.title = "Milk"
        itemArray.append(newItem1)
        
        let newItem2 = Item()
        newItem2.title = "Egg"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Meat"
        itemArray.append(newItem3)
        
        //MARK: UserDefaults()
        // the data persisted everytime launch the App again using UserDefaults method
        if let item = defaults.array(forKey: "TodoListArray") as? [Item]{
            itemArray = item
        }
    }
    //MARK: Table View DataSoure Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        //Ternary operator -->
        // value = condition ? trueValue : falseValue
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        
    // Checkmark eveytime select the cell
//        if itemArray[indexPath.row].done == true {
//            cell.accessoryType = .checkmark
//        }else{
//            cell.accessoryType = .none
//        }
        return cell
    }
    
    //MARK: TableView Delegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(itemArray[indexPath.row])
        
        tableView.deselectRow(at: indexPath, animated: true) // make a flash effect when ppl tap on the cell
        
        //Replace the code below: If it is true, change to false and reverse
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done // the clever way: reversing what it used to be
        
 //-->     true or false for checkmark
//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//        }else{
//            itemArray[indexPath.row].done = false
//        }
        //reload the TableView
        tableView.reloadData()
    }
    
    //MARK: Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField() // create a LOCAL variable within IBAction
        
        let alert:UIAlertController = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: UIAlertController.Style.alert)
        
        let action:UIAlertAction = UIAlertAction(title: "Add Item", style: UIAlertAction.Style.default) { (action) in
            //What happen when user click on Add Item button
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
            //set UserDefaults for data
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            self.tableView.reloadData() // reload the TableView
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField  //assign the LOCAL to a variable in closure
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    

}

