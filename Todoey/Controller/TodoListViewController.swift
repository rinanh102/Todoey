//
//  ViewController.swift
//  Todoey
//
//  Created by henry on 06/11/2018.
//  Copyright © 2018 HenryNguyen. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var itemArray = [Item]() // an array of item Objects
    // access to AppDelegate as an object, then tap into .persistentContainer.viewContext
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let defaults = UserDefaults()
    override func viewDidLoad() {
        super.viewDidLoad()
        
//    print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)) // print the path of data
        // call the func without any parameters
        loadItems()

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
        
        //remove the data from permanent storage
//        context.delete(itemArray[indexPath.row])
//        //remove the data from array
//        itemArray.remove(at: indexPath.row)
        
        //Replace the code below: If it is true, change to false and reverse
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done // the clever way: reversing what it used to be
        self.saveItems()
    }
    
    //MARK: Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField() // create a LOCAL variable within IBAction
        
        let alert:UIAlertController = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: UIAlertController.Style.alert)
        
        let action:UIAlertAction = UIAlertAction(title: "Add Item", style: UIAlertAction.Style.default) { (action) in
            //What happen when user click on "Add Item" button
            
            //create a new object of type item
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            self.itemArray.append(newItem)
            self.saveItems()
        } //--------
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField  //assign the LOCAL to a variable in closure
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    //MARK: Model Manupulation Method
    
    func saveItems(){
        do{
            try context.save()
        }catch{
            print("ERROR saving context: \(error)")
        }
        tableView.reloadData() // reload the TableView
    }
//Provide the default value In case when we retrive the func bbut dont pass anything (Item.fetchRequest())
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()){
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do{
            itemArray = try context.fetch(request)
        }catch{
            print("Error fetching data from context: \(error) ")
        }
    }
}

//MARK: - Search bar Method
extension TodoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(searchBar.text!)
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
       //Query the object from CoreData
        request.predicate  = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)

        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        // Run the request and Fetch the result  ;assign the result to itemArray
        loadItems(with: request)
        saveItems() // why?
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            saveItems()// why?
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}


