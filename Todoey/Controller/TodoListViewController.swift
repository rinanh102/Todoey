//
//  ViewController.swift
//  Todoey
//
//  Created by henry on 06/11/2018.
//  Copyright © 2018 HenryNguyen. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework
class TodoListViewController: SwipeTableViewController {
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    var todoItems : Results<Item>?
    // ditSet is gonna happen as soon as "selectedCategory has the value"
    var selectedCategory : Category?{
        didSet{
            //didSet when we call loadItems(), we already have some value for "selectedCategory"
             // call the func without any parameters
            loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
 
       
        
    }
    override func viewWillAppear(_ animated: Bool) {
         title = selectedCategory?.name
        
        guard let colourHex = selectedCategory?.hexColor else {fatalError()}
  
        updateNavBar(withHexCode: colourHex)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       
       updateNavBar(withHexCode: "89DBFE")
    }
    
    //MARK: - Nav Bar Setup Method
    func updateNavBar(withHexCode colourHexCode : String){
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist")}
        guard let navBarColor = UIColor(hexString: colourHexCode) else {fatalError()}
        navBar.barTintColor = navBarColor
        
        //tinColor is the color of Add button and
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
        
        searchBar.barTintColor = navBarColor
    }
    
    //MARK: Table View DataSoure Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row]{
            
            cell.textLabel?.text = item.title
            
            if let color = UIColor(hexString: selectedCategory!.hexColor)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)){
           
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat:  true)
            }
            
//            print("Version 1: \(CGFloat(indexPath.row / todoItems!.count))")
//
//            print("Version2: \(CGFloat(indexPath.row) / CGFloat(todoItems!.count))")
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
             item.done = !item.done
                }
            }catch{
                print("ERROR done status: \(error)")
            }
           tableView.reloadData()
        }
    }
    
    //MARK: - Delete Data from Swipe
    override func updateData(at indexPath: IndexPath) {
        //        super.updateData(at: indexPath)
        if let itemIsSelected = self.todoItems?[indexPath.row]{
            do{
                try self.realm.write {
                    self.realm.delete(itemIsSelected)
                }
            }catch{
                print("ERROR deleting Category: \(error)")
            }
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


