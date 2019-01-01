//
//  ViewController.swift
//  ToDoey
//
//  Created by omDroid on 1/1/19.
//  Copyright © 2019 iomDroid. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.PList");
    
    let defaults = UserDefaults.standard;
    override func viewDidLoad() {
        super.viewDidLoad()

        let newItem = Item();
        newItem.title = "1";
        newItem.done = false;
        itemArray.append(newItem);
        
        let newItem1 = Item();
        newItem1.title = "2";
        newItem1.done = false;
        itemArray.append(newItem1);
        
        let newItem2 = Item();
        newItem2.title = "3";
        newItem2.done = false;
        itemArray.append(newItem2);
        
        let newItem3 = Item();
        newItem3.title = "4";
        newItem3.done = false;
        itemArray.append(newItem3);
        
        
        // Do any additional setup after loading the view, typically from a nib.
        loadItems();
        
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
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems();
        tableView.deselectRow(at: indexPath, animated: true)
    }
    @IBAction func AddButtonPressed(_ sender: Any) {
        
        var textField = UITextField();
        let alert = UIAlertController(title: "Add New Today Item", message: "", preferredStyle:.alert );
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            var newItem = Item()
            newItem.title = textField.text!;
            self.itemArray.append(newItem);
            //self.defaults.setValue(self.itemArray, forKey: "ToDoListArrayObject");
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
        let encoder = PropertyListEncoder();
        do{
            let data = try encoder.encode(self.itemArray);
            try data.write(to: self.dataFilePath!)
        }
        catch{
            print(error);
        }
        self.tableView.reloadData();
    }
    
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder();
            
            do{
                itemArray = try decoder.decode([Item].self, from: data);
            }
            catch{
                print(error);
            }
        }
    }
}

