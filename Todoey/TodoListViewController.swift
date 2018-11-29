//
//  ViewController.swift
//  Todoey
//
//  Created by henry on 06/11/2018.
//  Copyright © 2018 HenryNguyen. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController{

    var itemArray = ["Egg", "Milk", "Meat"]
    let defaults = UserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: UserDefaults()
        // the data persisted everytime launch the App again using UserDefaults method
        if let item = defaults.array(forKey: "TodoListArray") as? [String]{
            itemArray = item
        }
    }
    //MARK: Table View DataSoure Methods
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    //MARK: TableView Delegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        
        tableView.deselectRow(at: indexPath, animated: true) // make a flash when ppl tap on the cell
        
       // Checkmark eveytime select the cell
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
    }
    
    //MARK: Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField() // create a LOCAL variable within IBAction
        
        let alert:UIAlertController = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: UIAlertController.Style.alert)
        
        let action:UIAlertAction = UIAlertAction(title: "Add Item", style: UIAlertAction.Style.default) { (action) in
            //What happen when user click on Add Item button
//            print(textField.text!)    // print text of LOCAL
            self.itemArray.append(textField.text!)
            
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

