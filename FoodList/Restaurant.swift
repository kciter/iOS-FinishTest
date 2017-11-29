//
//  Restaurant.swift
//  FoodList
//
//  Created by 이선협 on 2017. 11. 29..
//  Copyright © 2017년 이선협. All rights reserved.
//

import Foundation

struct Restaurant {
    let detailHash: String
    let image: String
    let alt: String
    var deliveryType: [String]
    let title: String
    let description: String
    var nPrice: String? = nil
    let sPrice: String
    var badge: [String]?
    
    init?(json: [String: Any]) {
        guard let detailHash = json["detail_hash"] as? String,
            let image = json["image"] as? String,
            let alt = json["alt"] as? String,
            let title = json["title"] as? String,
            let description = json["description"] as? String,
            let sPrice = json["s_price"] as? String,
            let deliveryTypeJson = json["delivery_type"] as? [String] else {
                return nil
        }
        
        self.detailHash = detailHash
        self.image = image
        self.alt = alt
        self.title = title
        self.description = description
        self.sPrice = sPrice
        
        if let nPrice = json["n_price"] as? String {
            self.nPrice = nPrice
        }
        
        self.deliveryType = []
        for string in deliveryTypeJson {
            self.deliveryType.append(string)
        }
        
        if let badgeJson = json["badge"] as? [String] {
            badge = []
            for string in badgeJson {
                self.badge?.append(string)
            }
        }
    }
}
