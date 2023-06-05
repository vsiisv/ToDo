//
//  SwipeTableViewController.swift
//  ToDo
//
//  Created by VASILY IKONNIKOV on 05.06.2023.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.rowHeight = 80.0
		tableView.register(SwipeTableViewCell.self, forCellReuseIdentifier: "cell")
    }
	
	// MARK: - TableView Datasource Methods
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SwipeTableViewCell
		cell.delegate = self
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeCellKit.SwipeActionsOrientation) -> [SwipeCellKit.SwipeAction]? {
		guard orientation == .right else { return nil }

		let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
			self.updateModel(at: indexPath)
		}
		
		deleteAction.image = UIImage(named: "delete")

		return [deleteAction]
	}
	
	func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
		var options = SwipeOptions()
		options.expansionStyle = .destructive
		return options
	}
	
	func updateModel(at indexPath: IndexPath) {
		// Update our data model
	}
}
