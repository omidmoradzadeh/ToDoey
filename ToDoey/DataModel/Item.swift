//
//  Item.swift
//  ToDoey
//
//  Created by omDroid on 1/1/19.
//  Copyright © 2019 iomDroid. All rights reserved.
//

import Foundation

class Item  : Encodable , Decodable{
    var title : String = "";
    var done : Bool = false;
}
