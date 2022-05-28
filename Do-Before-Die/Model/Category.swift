//
//  Category.swift
//  Do-Before-Die
//
//  Created by Bahadır Kılınç on 28.05.2022.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let notes = List<Note>()
}
