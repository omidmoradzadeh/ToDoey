//
//  ViewController.swift
//  ToDoey
//
//  Created by omDroid on 1/1/19.
//  Copyright © 2019 iomDroid. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    
    var itemArray = ["1","2","3"]
    
    let defaults = UserDefaults.standard;
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let items  = defaults.array(forKey: "ToDoListArray") as? [String] {
            itemArray = items;
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row];
        return cell;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none;
        }
        else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark;
        }
    }
    @IBAction func AddButtonPressed(_ sender: Any) {
        
        var textField = UITextField();
        let alert = UIAlertController(title: "Add New Today Item", message: "", preferredStyle:.alert );
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            self.itemArray.append(textField.text!)
            self.defaults.setValue(self.itemArray, forKey: "ToDoListArray");
            self.tableView.reloadData();
        }
        
        alert.addTextField { (alerttextField) in
            alerttextField.placeholder = "Create  New Item";
            textField = alerttextField;
        }
        alert.addAction(action);
        present(alert, animated: true,completion: nil);
    }
}

