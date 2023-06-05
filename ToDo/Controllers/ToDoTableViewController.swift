//
//  ToDoTableViewController.swift
//  ToDo
//
//  Created by VASILY IKONNIKOV on 29.05.2023.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoTableViewController: SwipeTableViewController {
	
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
//		style()
//		loadItems()
		searchController.searchBar.delegate = self
    }
	
	override func viewWillAppear(_ animated: Bool) {
		style()
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
						item.date = Date()
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
        //let cell = tableView.dequeueReusableCell(withIdentifier: "list", for: indexPath)
		let cell = super.tableView(tableView, cellForRowAt: indexPath)
		
		var content = cell.defaultContentConfiguration()
		
		if let item = array?[indexPath.row] {
			content.text = item.title
			cell.accessoryType = (item.done == true ? .checkmark : .none)
			
			let categoryColor = UIColor(hexString: selectedCategory?.color ?? "#00FFFF")
			
			if let color = categoryColor?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(array!.count)) {
				cell.backgroundColor = color
				content.textProperties.color = ContrastColorOf(color, returnFlat: true)
			}
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
//					realm.delete(item)
					item.done = !item.done
				}
			} catch {
				print("Error saving done status, \(error)")
			}
		}
//		tableView.deleteRows(at: [indexPath], with: .automatic)
		tableView.reloadRows(at: [indexPath], with: .automatic)
	}
	
	// MARK: - Delete data from swipe
	
	override func updateModel(at indexPath: IndexPath) {
		if let item = array?[indexPath.row] {
			do {
				try realm.write{
					realm.delete(item)
				}
			} catch {
				print("Error deleting category, \(error)")
			}
		}
	}
}

// MARK: - SearchBar Delegate

extension ToDoTableViewController: UISearchBarDelegate {
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		
		array = array?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "date", ascending: true)
		tableView.reloadData()
	}

	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		if searchBar.text?.count == 0 {
			loadItems()
			print(1)
//			DispatchQueue.main.async {
//				searchBar.resignFirstResponder()
//			}
		} else {
			array = array?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "date", ascending: true)
			tableView.reloadData()
		}
	}

	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		if searchBar.text!.count > 0 {
			loadItems()
		}
	}
}

// MARK: - Style

private extension ToDoTableViewController {
	func style() {
		
		if let colorHex = selectedCategory?.color {
			
			if let navBarColor = UIColor(hexString: colorHex) {
				let navigationBarAppearance = UINavigationBarAppearance()
				navigationBarAppearance.backgroundColor = navBarColor
				navigationController?.navigationBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
				navigationBarAppearance.titleTextAttributes = [
					.foregroundColor: ContrastColorOf(navBarColor, returnFlat: true)
				]
				navigationBarAppearance.largeTitleTextAttributes = [
					.foregroundColor: ContrastColorOf(navBarColor, returnFlat: true)
				]
				
				navigationController?.navigationBar.standardAppearance = navigationBarAppearance
				navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
				
				searchController.searchBar.backgroundColor = navBarColor
			}
		}
		
		navigationController?.navigationBar.prefersLargeTitles = true
		
		navigationItem.searchController = searchController
		navigationItem.title = selectedCategory?.name
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			barButtonSystemItem: .add,
			target: self,
			action: #selector(addList)
		)
		
		tableView.separatorStyle = .none
		
		
	}
}
