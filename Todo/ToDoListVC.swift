//
//  ViewController.swift
//  Todo
//
//  Created by Islam Elgaafary on 9/10/18.
//  Copyright © 2018 Islam Elgaafary. All rights reserved.
//

import UIKit

class ToDoListVC: UITableViewController {

    var toDoList = ["A" , "B" , "C"]
    let defaults = UserDefaults.standard
    @IBOutlet var todo: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let list = defaults.array(forKey: "ToDoListArray") as? [String] {
            toDoList = list
        }
      todo.delegate = self
    }
    
    //MARK - TableView DataSource & Delegate Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = toDoList[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoList.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // print("\(toDoList[indexPath.row])")
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK - AddBtnPressed
    
    @IBAction func AddBtnPressed(_ sender: UIBarButtonItem) {
        var inputTxtField = UITextField()
        
       let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
       let actionAlert = UIAlertAction(title: "Add", style: .default) { (action) in
       
            self.toDoList.append(inputTxtField.text!)
            self.defaults.set(self.toDoList, forKey: "ToDoListArray")
            self.tableView.reloadData()
            
        }
        
       alert.addAction(actionAlert)
        
        alert.addTextField { (textField) in
            inputTxtField = textField
            textField.placeholder = "Create new item"
        }
        
        present(alert, animated: true, completion: nil)
    }
  
    

}

