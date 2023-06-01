//
//  ToDoTableViewController.swift
//  ToDo
//
//  Created by VASILY IKONNIKOV on 29.05.2023.
//

import UIKit
import CoreData

class ToDoTableViewController: UITableViewController {
	
	private var array = [Item]()
	private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

	// MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "list")
		style()
		loadItems()
    }
	
	// MARK: - Methods
	
	// Add item on TableView
	@objc func addList() {
		var textField = UITextField()
		
		let alert = UIAlertController(title: "Add List", message: nil, preferredStyle: .alert)
		let action = UIAlertAction(title: "Add", style: .default) { actin in
			if let text = textField.text, text != "" {
				
				let item = Item(context: self.context)
				item.title = text
				item.done = false
				
				self.array.append(item)
				self.tableView.insertRows(at: [IndexPath(row: self.array.count - 1, section: 0)], with: .automatic)
			}
			
			self.saveItems()
		}
		
		alert.addTextField { alertTextField in
			alertTextField.placeholder = "Write a text"
			textField = alertTextField
		}
		alert.addAction(action)
		present(alert, animated: true)
	}
	
	// Save item in CoreData
	private func saveItems() {
		do {
			try context.save()
		} catch {
			print("Error saving context \(error)")
		}
	}
	
	// Load Items from CoreDate
	private func loadItems() {
		let request: NSFetchRequest<Item> = Item.fetchRequest()
		do {
			array = try context.fetch(request)
		} catch {
			print("Error fetching data from context \(error)")
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
