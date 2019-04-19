//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Idriss Ben Khedija on 17/04/2019.
//  Copyright © 2019 Idriss Ben Khedija. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {

    var categoryArray = [Category] ()
    
    let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Category.plist")
    
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
    }
    
    // MARK - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category =  categoryArray[indexPath.row]
        cell.textLabel?.text = category.name
        
        return cell
    }
    
    
    // MARK - TableView Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let  destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathsForSelectedRows {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField ()
        
        let alert = UIAlertController (title: "Add new Todoey Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category (context: self.context)
            newCategory.name = textField.text!
            
            self.categoryArray.append(newCategory)
            
            self.saveItems()
            
        }
        
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
            
        }
        
        present (alert, animated: true, completion: nil)
    }
    
// MARK - Data Manipulation Method
    
    func saveItems () {
        
        do  {
            try context.save()
        } catch {
            print ("error")
        }
        tableView.reloadData()
    }
    
    func loadItems (with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print ("error 3")
        }
    }
}
