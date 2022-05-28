//
//  Note.swift
//  Do-Before-Die
//
//  Created by Bahadır Kılınç on 28.05.2022.
//

import Foundation
import RealmSwift

class Note: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "notes")
}
