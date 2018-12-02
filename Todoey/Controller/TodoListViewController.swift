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
   
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist") // the first item of array
    let defaults = UserDefaults()
    override func viewDidLoad() {
        super.viewDidLoad()
    
        print(dataFilePath)
        
        self.loadItems()
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
        return cell
    }
    
    //MARK: TableView Delegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true) // make a flash effect when ppl tap on the cell
        
        //Replace the code below: If it is true, change to false and reverse
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done // the clever way: reversing what it used to be
        self.saveItems()
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
            self.saveItems()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField  //assign the LOCAL to a variable in closure
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    //MARK: Model Manupulation Method
    
    func saveItems(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }catch{
            print("ERROR encoding: \(error)")
        }
        tableView.reloadData() // reload the TableView
    }

    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                itemArray = try decoder.decode([Item].self, from: data)
            }catch{
                print("ERROR decoding: \(error)")
            }
            
        }
    }
}

