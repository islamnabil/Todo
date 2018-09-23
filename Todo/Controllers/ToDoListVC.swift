//
//  ViewController.swift
//  Todo
//
//  Created by Islam Elgaafary on 9/10/18.
//  Copyright © 2018 Islam Elgaafary. All rights reserved.
//

import UIKit
import CoreData

class ToDoListVC: UITableViewController {

    var toDoList = [Item]()
    var selectedCategoty : Category? {
        didSet {
            LoadItems()

        }
    }
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
//
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet var todo: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath)
        // Do any additional setup after loading the view, typically from a nib.
//        let newItem = Item()
//        newItem.title = "Visit"
//        toDoList.append(newItem)
        
      todo.delegate = self
        
    }
    
    //MARK: - TableView DataSource & Delegate Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
       
        let item = toDoList[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryType =  item.done ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoList.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//       context.delete(toDoList[indexPath.row])
//        toDoList.remove(at: indexPath.row)
        
        toDoList[indexPath.row].done = !toDoList[indexPath.row].done
        saveItem()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - AddBtnPressed
    
    @IBAction func AddBtnPressed(_ sender: UIBarButtonItem) {
        var inputTxtField = UITextField()
        
       let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
       let actionAlert = UIAlertAction(title: "Add", style: .default) { (action) in

        
       let newItem = Item(context: self.context)
       newItem.title = inputTxtField.text!
       newItem.done = false
        newItem.parentCategory = self.selectedCategoty
        self.toDoList.append(newItem)
        
        self.saveItem()
        
        
        }
        
       alert.addAction(actionAlert)
        
        alert.addTextField { (textField) in
            inputTxtField = textField
            textField.placeholder = "Create new item"
        }
        
        present(alert, animated: true, completion: nil)
    }
  
    
    func saveItem() {
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
    
    func LoadItems( with request: NSFetchRequest<Item> = Item.fetchRequest() , predicate : NSPredicate? = nil) {
    
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategoty!.name!)
        
        if let additionalPredicate = predicate {
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [additionalPredicate , categoryPredicate])
            request.predicate = compoundPredicate
        }else {
            request.predicate = categoryPredicate
        }
        
       
        
        do {
            try toDoList = context.fetch(request)
        }catch {
            print("Error fetching data! \(error)")
        }
        print("LOAD \(request)")
         tableView.reloadData()

    }
}
//MARK: - Search bar methods
extension ToDoListVC : UISearchBarDelegate {
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//       request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//       request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        LoadItems(with: request)
//
//
//    }
//
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      print(searchBar.text!.count)
        if searchBar.text?.count == 0 {
            LoadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }else{
        let request : NSFetchRequest<Item> = Item.fetchRequest()

        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)

        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]

        LoadItems(with: request ,predicate: predicate)
    }
    }
}

