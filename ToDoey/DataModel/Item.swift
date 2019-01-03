//
//  Item.swift
//  ToDoey
//
//  Created by omDroid on 1/3/19.
//  Copyright © 2019 iomDroid. All rights reserved.
//

import Foundation
import RealmSwift;

class Item : Object {
    @objc dynamic var title : String = "";
    @objc dynamic var done : Bool = false;
    @objc dynamic var createDate : Date?;
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items");
}
