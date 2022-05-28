//
//  NoteListViewController.swift
//  Do-Before-Die
//
//  Created by Bahadır Kılınç on 28.05.2022.
//

import UIKit
import RealmSwift
import ChameleonFramework

class NoteListViewController: SwipeTableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var toDoItems: Results<Note>?
    let realm = try! Realm()
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.barTintColor = UIColor(named: ColorConstants.navyBlue)
        searchBar.searchTextField.textColor = UIColor(named: ColorConstants.lightPink)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let category = selectedCategory {
            title = category.name
        }
        searchBar.barTintColor = UIColor(named: ColorConstants.navyBlue)
    }
    
    //Mark - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = toDoItems?[indexPath.row] { // you do not need this too
            cell.textLabel?.text = item.title
            cell.backgroundColor = UIColor(named: ColorConstants.lightBlue)
            cell.textLabel?.textColor = UIColor(named: ColorConstants.lightPink)
            cell.accessoryType = item.done ? .checkmark : .none
            cell.tintColor = UIColor(named: ColorConstants.lightPink)
            
        } else {
            cell.textLabel?.text = "No Notes Added"
        }
        
        return cell
    }
    
    //Mark - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write{
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Note", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Note()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.notes.append(newItem)
                    }
                } catch {
                    print("Error saving new notes, \(error)")
                }
            }
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new note"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //Mark - Model Manipulation Methods
    func loadItems() {
        toDoItems = selectedCategory?.notes.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write{
                    realm.delete(item)
                }
            } catch {
                print("Error deleting item, \(error)")
            }
        }
    }

        
        
        
    
}


//Mark: - Searchbar delegate methods
extension NoteListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) { // searching a note from the list by sorting with its title
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    

}
