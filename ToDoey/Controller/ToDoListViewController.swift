//
//  ViewController.swift
//  ToDoey
//
//  Created by omDroid on 1/1/19.
//  Copyright © 2019 iomDroid. All rights reserved.
//

import UIKit
import CoreData;

class ToDoListViewController: UITableViewController {

    
    var itemArray = [Item]();
    var selectedCategory : Category? {
        didSet{
            loadItems();
        }
    };
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.PList");
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
    
    let defaults = UserDefaults.standard;
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath);
        let item = itemArray[indexPath.row];
        cell.textLabel?.text = item.title;
        cell.accessoryType = item.done ? .checkmark : .none
        return cell;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done;
        context.delete(itemArray[indexPath.row]);
        itemArray.remove(at: indexPath.row);
        saveItems();
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    @IBAction func AddButtonPressed(_ sender: Any) {
        
        var textField = UITextField();
        let alert = UIAlertController(title: "Add New Today Item", message: "", preferredStyle:.alert );
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item(context: self.context);
            newItem.title = textField.text!;
            newItem.done = false;
            newItem.parentCategory = self.selectedCategory;
            self.itemArray.append(newItem);
            self.saveItems();
        }
        
        alert.addTextField { (alerttextField) in
            alerttextField.placeholder = "Create  New Item";
            textField = alerttextField;
        }
        alert.addAction(action);
        present(alert, animated: true,completion: nil);
    }
    
    func saveItems(){
        do{
            try context.save();
        }
        catch{
            print("error saving Context with \(error)");
        }
        self.tableView.reloadData();
    }
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest() , predicate : NSPredicate? = nil){
        let categoryPredicate =  NSPredicate(format: "parentCategory.name MATCHES %@", argumentArray: [selectedCategory!.name!] );
        do{
            if let aditionalPredicate = predicate {
                request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate , aditionalPredicate]);
            }
            else{
                request.predicate = predicate;
            }
            itemArray =  try context.fetch(request);
        }
        catch{
            print(error)
        }
        self.tableView.reloadData();
    }
}

//MARK: Search bar methods
extension ToDoListViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest();
        let predicate  = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!);
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)];
        loadItems(with: request , predicate: predicate);

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
