//
//  ToDoTableViewController.swift
//  ToDo
//
//  Created by VASILY IKONNIKOV on 29.05.2023.
//

import UIKit

class ToDoTableViewController: UITableViewController {
	
	private var array = [Item]()
	
	let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
//	let defaults = UserDefaults.standard

	// MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
		
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "list")
		style()
		
//		if let array = defaults.array(forKey: "ToDoList") as? [Item] {
//			self.array = array
//		}
		
		loadItems()
		
    }
	
	// MARK: - Methods
	
	// Add item on TableView
	@objc func addList() {
		var textField = UITextField()
		
		let alert = UIAlertController(title: "Add List", message: nil, preferredStyle: .alert)
		let action = UIAlertAction(title: "Add", style: .default) { actin in
			if let text = textField.text, text != "" {
				let item = Item(title: text, done: false)
				self.array.append(item)
				self.tableView.insertRows(at: [IndexPath(row: self.array.count - 1, section: 0)], with: .automatic)
			}
			
//			self.defaults.set(self.array, forKey: "ToDoList")
			
			self.saveItems()
		}
		
		alert.addTextField { alertTextField in
			alertTextField.placeholder = "Write a text"
			textField = alertTextField
		}
		alert.addAction(action)
		present(alert, animated: true)
	}
	
	// Save item in plist
	private func saveItems() {
		let encoder = PropertyListEncoder()
		do {
			let data = try encoder.encode(array)
			try data.write(to: dataFilePath!)
		} catch {
			print("ERRRRROOOOOOORRRRR - \(error)")
		}
	}
	
	// Load Items from plist
	private func loadItems() {
		if let dataFilePath {
			guard let data = try? Data(contentsOf: dataFilePath) else { return }
			let decoder = PropertyListDecoder()
			do {
				array = try decoder.decode([Item].self, from: data)
			} catch {
				print("Error decoding item array \(error)")
			}
		}
	}

    // MARK: - Table view data source
	
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return array.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "list", for: indexPath)
		let item = array[indexPath.row]
		
		var content = cell.defaultContentConfiguration()
		content.text = array[indexPath.row].title
		
		cell.accessoryType = (item.done == true ? .checkmark : .none)

		cell.contentConfiguration = content

        return cell
    }
	
	// MARK: - TableView Delegate Methods
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		array[indexPath.row].done = !array[indexPath.row].done
		
		saveItems()

		tableView.reloadRows(at: [indexPath], with: .automatic)
	
//		let accessory = tableView.cellForRow(at: indexPath)?.accessoryType
//		tableView.cellForRow(at: indexPath)?.accessoryType = (accessory == .checkmark ? .none : .checkmark)
		
	}
   
}

private extension ToDoTableViewController {
	func style() {
		navigationItem.title = "Lists"
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			barButtonSystemItem: .add,
			target: self,
			action: #selector(addList)
		)
	}
}
