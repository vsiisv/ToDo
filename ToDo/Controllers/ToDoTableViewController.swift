//
//  ToDoTableViewController.swift
//  ToDo
//
//  Created by VASILY IKONNIKOV on 29.05.2023.
//

import UIKit
import RealmSwift

class ToDoTableViewController: UITableViewController {
	
	var array: Results<Item>?
	let realm = try! Realm()
	
	var selectedCategory: Category? {
		didSet {
			loadItems()
		}
	}
	
	private let searchController = UISearchController()
	
	// MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "list")
		style()
//		loadItems()
		
//		searchController.searchBar.delegate = self
    }
	
	// MARK: - Methods
	
	// Add item on TableView
	@objc func addList() {
		var textField = UITextField()
		
		let alert = UIAlertController(title: "Add List", message: nil, preferredStyle: .alert)
		let action = UIAlertAction(title: "Add", style: .default) { actin in
			if let text = textField.text, text != "" {
				guard let currentCategory = self.selectedCategory else { return }
				do {
					try self.realm.write {
						let item = Item()
						item.title = text
						currentCategory.items.append(item)
					}
				} catch {
					print("Error saving new items, \(error)")
				}
			}
			
//			if let array = self.array {
//				self.tableView.insertRows(at: [IndexPath(row: array.count - 1, section: 0)], with: .automatic)
//			}
			self.tableView.reloadData()
		}
		
		alert.addTextField { alertTextField in
			alertTextField.placeholder = "Write a text"
			textField = alertTextField
		}
		alert.addAction(action)
		present(alert, animated: true)
	}
	
	// Save item in CoreData
//	private func saveItems(item: Item) {
//		do {
////			try context.save()
//			try realm.write {
//				realm.add(item)
//			}
//		} catch {
//			print("Error saving context \(error)")
//		}
//	}
	
	// Load Items from Realm
	private func loadItems() {
		array = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
		tableView.reloadData()
	}

    // MARK: - Table view data source
	
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return array?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "list", for: indexPath)
		
		var content = cell.defaultContentConfiguration()
		
		if let item = array?[indexPath.row] {
			content.text = item.title
			cell.accessoryType = (item.done == true ? .checkmark : .none)
		} else {
			content.text = "No items added"
		}
		cell.contentConfiguration = content
        return cell
    }
	
	// MARK: - TableView Delegate Methods
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		if let item = array?[indexPath.row] {
			do {
				try realm.write{
					realm.delete(item)
//					item.done = !item.done
				}
			} catch {
				print("Error saving done status, \(error)")
			}
		}
		tableView.deleteRows(at: [indexPath], with: .automatic)
//		tableView.reloadRows(at: [indexPath], with: .automatic)
	}
}

// MARK: - SearchBar Delegate

//extension ToDoTableViewController: UISearchBarDelegate {
//	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
////		let request: NSFetchRequest<Item> = Item.fetchRequest()
////
////		// FIXME: Optional binding
////		let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
////
////		request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
////		loadItems(with: request, predicate: predicate)
//	}
//
//	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//		if searchBar.text?.count == 0 {
//			loadItems()
//
////			DispatchQueue.main.async {
////				searchBar.resignFirstResponder()
////			}
//		} else {
//			let request: NSFetchRequest<Item> = Item.fetchRequest()
//
//			// FIXME: Optional binding
//			let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//			request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//			loadItems(with: request, predicate: predicate)
//
//		}
//	}
//
//	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//		if searchBar.text!.count > 0 {
//			loadItems()
//		}
//	}
//}

// MARK: - Style

private extension ToDoTableViewController {
	func style() {
		
		navigationItem.searchController = searchController
		navigationItem.title = "Lists"
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			barButtonSystemItem: .add,
			target: self,
			action: #selector(addList)
		)
	}
}
