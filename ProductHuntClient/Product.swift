//
//  Product.swift
//  ProductHuntClient
//
//  Created by Vadim on 7/7/17.
//  Copyright © 2017 Vadim Prosviryakov. All rights reserved.
//

import ObjectMapper

final class Posts: Mappable {
    var posts: [Product] = []
    init?(map: Map) {}
    func mapping(map: Map) {
        posts <- map["posts"]
    }
}

final class Product: Mappable {
    private(set) var thumbnailProduct: Dictionary<String, AnyObject>?
    private(set) var nameProduct: String = ""
    private(set) var descriptionProduct: String = ""
    private(set) var upvotesProduct: Int = 0
    private(set) var redirectUrl: String = ""
    private(set) var screenshotUrl: Dictionary<String, AnyObject>?


    init?(map: Map) {}
    func mapping(map: Map) {
        nameProduct <- map["name"]
        descriptionProduct <- map["tagline"]
        upvotesProduct <- map["votes_count"]
        redirectUrl <- map["redirect_url"]
        screenshotUrl <- map["screenshot_url"]
        thumbnailProduct <- map["thumbnail"]
    }
}
