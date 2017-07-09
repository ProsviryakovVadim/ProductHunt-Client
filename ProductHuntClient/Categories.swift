//
//  Categories.swift
//  ProductHuntClient
//
//  Created by Vadim on 7/8/17.
//  Copyright © 2017 Vadim Prosviryakov. All rights reserved.
//

import ObjectMapper

final class Categories: Mappable {
    var category: [Category] = []
    init?(map: Map) {}
    func mapping(map: Map) {
        category <- map["categories"]
    }
}

final class Category: Mappable {
    private(set) var category: String = ""
    init?(map: Map) {}
    func mapping(map: Map) {
        category <- map["name"]
    }
}
