//
//  CategoryTableViewController.swift
//  ToDo
//
//  Created by VASILY IKONNIKOV on 02.06.2023.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
	
	private var categories = [CategoryList]()
	private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "category")
		
		styleOfNavigationController()
		
//		print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
		
		loadCategories()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "category", for: indexPath)

		var content = cell.defaultContentConfiguration()
		content.text = categories[indexPath.row].name
		cell.contentConfiguration = content

        return cell
    }
	
	// MARK: - TableViewDelegate
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let vc = ToDoTableViewController()
		
		vc.selectedCategory = categories[indexPath.row]
		
		navigationController?.pushViewController(vc, animated: true)
	}

}

// MARK: - Methods

private extension CategoryTableViewController {
	@objc func addCategory() {
		let category = CategoryList(context: self.context)
		category.name = "New category 3"
		categories.append(category)
		self.tableView.insertRows(at: [IndexPath(row: self.categories.count - 1, section: 0)], with: .automatic)
		
		saveCategory()
	}
	
	// Save item in CoreData
	private func saveCategory() {
		do {
			try context.save()
		} catch {
			print("Error saving context \(error)")
		}
	}
	
	// Load Items from CoreData
	private func loadCategories(with request: NSFetchRequest<CategoryList> = CategoryList.fetchRequest()) {
		do {
			categories = try context.fetch(request)
		} catch {
			print("Error fetching data from context \(error)")
		}
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
