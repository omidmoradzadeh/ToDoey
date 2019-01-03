//
//  Category.swift
//  ToDoey
//
//  Created by omDroid on 1/3/19.
//  Copyright © 2019 iomDroid. All rights reserved.
//

import Foundation
import RealmSwift;

class Category : Object{
    @objc dynamic var name : String = "";
    let items = List<Item>();
    
}

