//
//  Category.swift
//  ToDo
//
//  Created by VASILY IKONNIKOV on 03.06.2023.
//

import Foundation
import RealmSwift

class Category: Object {
	@objc dynamic var name: String = ""
	@objc dynamic var color: String = ""
	let items = List<Item>()
}
