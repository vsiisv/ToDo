//
//  CategoryTableViewController.swift
//  ToDo
//
//  Created by VASILY IKONNIKOV on 02.06.2023.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {
	
	let realm = try! Realm()
	
	private var categories: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()

		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "category")
		
		styleOfNavigationController()
		
//		print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
		
		loadCategories()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return categories?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "category", for: indexPath)

		var content = cell.defaultContentConfiguration()
		content.text = categories?[indexPath.row].name ?? "No Categories Added yet"
		cell.contentConfiguration = content

        return cell
    }
	
	// MARK: - TableViewDelegate
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let vc = ToDoTableViewController()
		
		vc.selectedCategory = categories?[indexPath.row]
		
		navigationController?.pushViewController(vc, animated: true)
	}

}

// MARK: - Methods

private extension CategoryTableViewController {
	@objc func addCategory() {
		let category = Category()
		category.name = "New category 7"
		
		save(category: category)
		
		if let categories = self.categories {
			self.tableView.insertRows(at: [IndexPath(row: categories.count - 1, section: 0)], with: .automatic)
		}
	}
	
	// Save item in Realm
	private func save(category: Category) {
		do {
			try realm.write {
				realm.add(category)
			}
		} catch {
			print("Error saving context \(error)")
		}
	}
	
	// Load Items from Realm
	private func loadCategories() {
		categories = realm.objects(Category.self)
		tableView.reloadData()
	}
}

// MARK: - Style

private extension CategoryTableViewController {
	func styleOfNavigationController() {
		title = "Category"

		navigationItem.rightBarButtonItem = UIBarButtonItem(
			barButtonSystemItem: .add,
			target: self,
			action: #selector(addCategory)
		)
	}
}
