//
//  TableViewController.swift
//  ToDoey
//
//  Created by omDroid on 1/3/19.
//  Copyright © 2019 iomDroid. All rights reserved.
//

import UIKit
import CoreData;

class CategoryViewController : UITableViewController {

    var categoryArray = [Category]();
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories();
    }
        
    
    
    //MARK: - TableView Datasource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath);
        cell.textLabel?.text = categoryArray[indexPath.row].name;
        return cell;
    }
    
    //MARK: - TableView Delegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self);
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController;
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row];
        }
    }
    
    //MARK: - TableView Model Manipulate Methods
    
    func saveCategories(){
        do{
            try context.save();
        }
        catch{
            print("error saving Context with \(error)");
        }
        tableView.reloadData();
        
    }
    
    func loadCategories(){
        let request : NSFetchRequest<Category> = Category.fetchRequest();
        do{
            categoryArray =  try context.fetch(request);
        }
        catch{
            print("error saving Context with \(error)");
        }
        tableView.reloadData();
    }
    
    //MARK: - Add New Category
    @IBAction func addButtonPressed(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert);
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category(context: self.context);
            newCategory.name = textField.text;
            self.categoryArray.append(newCategory);
            self.saveCategories();
        }
        
        alert.addAction(action);
        alert.addTextField { (field) in
            textField = field;
            textField.placeholder = "Add New Category";
        }
        present(alert,animated: true,completion: nil);
    }
    
    
    
}
