//
//  CategoryTableViewController.swift
//  Todo
//
//  Created by Islam Elgaafary on 9/21/18.
//  Copyright © 2018 Islam Elgaafary. All rights reserved.
//

import UIKit
import CoreData
import SwipeCellKit

class CategoryTableViewController: UITableViewController  {
     var categoryItems = [Category]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    @IBOutlet var CategoryCell: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
       LoadCategories()
        print("FILE : \(dataFilePath)")
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
        let cell  = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        
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
//MARK: - Swipe Cell Delegate Method

extension CategoryTableViewController : SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            let deletedItem  = self.categoryItems.remove(at: indexPath.row)
            self.context.delete(deletedItem)
            self.saveCategories()
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    
    func collectionView(_ collectionView: UICollectionView, editActionsOptionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
    
    
}
