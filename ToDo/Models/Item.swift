//
//  Item.swift
//  ToDo
//
//  Created by VASILY IKONNIKOV on 03.06.2023.
//

import Foundation
import RealmSwift

class Item: Object {
	@objc dynamic var title: String = ""
	@objc dynamic var done: Bool = false
	var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
