//
//  TableViewController.swift
//  ToDoey
//
//  Created by omDroid on 1/3/19.
//  Copyright © 2019 iomDroid. All rights reserved.
//

import UIKit
import CoreData;
import RealmSwift;

class CategoryViewController : UITableViewController {

    var categories : Results<Category>?;
    let realm = try! Realm();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories();
    }
        
    
    
    //MARK: - TableView Datasource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath);
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Category Added Yet!";
        return cell;
    }
    
    //MARK: - TableView Delegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self);
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController;
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row];
        }
    }
    
    //MARK: - TableView Model Manipulate Methods
    
    func saveCategories(category : Category){
        do{
            try realm.write {
                realm.add(category);
            }
        }
        catch{
            print("error saving Context with \(error)");
        }
        tableView.reloadData();
        
    }
    
    func loadCategories(){
        categories = realm.objects(Category.self);
        
        tableView.reloadData();
    }
    
    //MARK: - Add New Category
    @IBAction func addButtonPressed(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert);
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!;
            self.saveCategories(category: newCategory);
        }
        
        alert.addAction(action);
        alert.addTextField { (field) in
            textField = field;
            textField.placeholder = "Add New Category";
        }
        present(alert,animated: true,completion: nil);
    }
    
    
    
}
