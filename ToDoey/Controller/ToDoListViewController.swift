//
//  ViewController.swift
//  ToDoey
//
//  Created by omDroid on 1/1/19.
//  Copyright © 2019 iomDroid. All rights reserved.
//

import UIKit
import CoreData;
import RealmSwift;

class ToDoListViewController: UITableViewController {

    
    var todoItems : Results<Item>?;
    let realm = try! Realm();
    
    var selectedCategory : Category? {
        didSet{
            loadItems();
        }
    };
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.PList");
    
    let defaults = UserDefaults.standard;
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath);
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title;
            cell.accessoryType = item.done ? .checkmark : .none;
        }
        else{
            cell.textLabel?.text = "No Item's Added";
            cell.accessoryType =  .none;
        }
        
        return cell;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let item = todoItems?[indexPath.row] {
            do{
                try realm.write {
                        //realm.delete(item);
                        item.done = !item.done;
                }
            } catch {
                print("Error Saving Don sataus \(error))");
            }
        }
        tableView.reloadData();
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func AddButtonPressed(_ sender: Any) {

        var textField = UITextField();
        let alert = UIAlertController(title: "Add New Today Item", message: "", preferredStyle:.alert );
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in

            
            if let currentCategory = self.selectedCategory {
                do{
                    try self.realm.write {
                        let newItem = Item();
                        newItem.title = textField.text!;
                        newItem.done = false;
                        newItem.createDate = Date();
                        currentCategory.items.append(newItem);
                    }
                }
                catch{
                    print("Erorr in add data to realm")
                }
            }
            self.tableView.reloadData();
            
            
        }

        alert.addTextField { (alerttextField) in
            alerttextField.placeholder = "Create  New Item";
            textField = alerttextField;
        }
        alert.addAction(action);
        present(alert, animated: true,completion: nil);
    }

    func loadItems(){

        todoItems = selectedCategory?.items.sorted(byKeyPath: "createDate", ascending: true );
        tableView.reloadData();
    }
}
//
////MARK: Search bar methods
extension ToDoListViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cs]  %a", searchBar.text!).sorted(byKeyPath: "createDate", ascending: true);
        tableView.reloadData();
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems();
            DispatchQueue.main.async {
                searchBar.resignFirstResponder();
            };

        }
    }


}
