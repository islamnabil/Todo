//
//  CategoryTableViewController.swift
//  Todo
//
//  Created by Islam Elgaafary on 9/21/18.
//  Copyright © 2018 Islam Elgaafary. All rights reserved.
//

import UIKit
import CoreData
class CategoryTableViewController: UITableViewController {
     var categoryItems = [Category]()
    
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    @IBOutlet var CategoryCell: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       LoadCategories()
    }

    @IBAction func AddBtnPressed(_ sender: UIBarButtonItem) {
        var inputTxtField = UITextField()

        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let actionAlert = UIAlertAction(title: "Add", style: .default) { (action) in
            
            
            let newCategory = Category(context: self.context)
            newCategory.name = inputTxtField.text!
            self.categoryItems.append(newCategory)
            
            self.saveCategories()
            
            
        }
        
        alert.addAction(actionAlert)
        
        alert.addTextField { (textField) in
            inputTxtField = textField
            textField.placeholder = "Create new Category"
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let item = categoryItems[indexPath.row]
        cell.textLabel?.text = item.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryItems.count
    }
    
    
    //MARK: - TableView Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       let destinationVC = segue.destination as! ToDoListVC
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategoty = categoryItems[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods
    func saveCategories() {
        // let encoder = PropertyListEncoder()
        
        do {
            //            let data = try encoder.encode(self.toDoList)
            //            try data.write(to: self.dataFilePath!)
            try context.save()
        }catch {
            print("ERROR : Error Saving context, \(error)")
        }
        self.tableView.reloadData()
    }
    
    func LoadCategories( with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            try categoryItems = context.fetch(request)
        }catch {
            print("Error fetching data! \(error)")
        }
        print("LOAD \(request)")
        tableView.reloadData()
        
    }
}
