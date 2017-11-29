//
//  RestaurantDetail.swift
//  FoodList
//
//  Created by 이선협 on 2017. 11. 29..
//  Copyright © 2017년 이선협. All rights reserved.
//

import Foundation

struct RestaurantDetail {
    let hash: String
    let topImage: String
    var thumbImages: [String]
    var productDescription: String
    let title: String
    let point: String
    let deliveryInfo: String
    let deliveryFee: String
    let price: String
    var detailSectionImages: [String]
    
    init?(json: [String: Any], title: String) {
        guard let hash = json["hash"] as? String,
            let topImage = (json["data"] as? [String: Any])?["top_image"] as? String,
            let deliveryInfo = (json["data"] as? [String: Any])?["delivery_info"] as? String,
            let deliveryFee = (json["data"] as? [String: Any])?["delivery_fee"] as? String,
            let point = (json["data"] as? [String: Any])?["point"] as? String,
            let productDescription = (json["data"] as? [String: Any])?["product_description"] as? String,
            let price = ((json["data"] as? [String: Any])?["prices"] as? [String])?.last,
            let thumbImageJson = (json["data"] as? [String: Any])?["thumb_images"] as? [String],
            let detailSectionImagesJson = (json["data"] as? [String: Any])?["detail_section"] as? [String] else {
                return nil
        }
        
        self.hash = hash
        self.topImage = topImage
        self.point = point
        self.productDescription = productDescription
        self.deliveryInfo = deliveryInfo
        self.deliveryFee = deliveryFee
        self.price = price
        self.title = title
        
        self.thumbImages = []
        for string in thumbImageJson {
            self.thumbImages.append(string)
        }
        
        self.detailSectionImages = []
        for string in detailSectionImagesJson {
            self.detailSectionImages.append(string)
        }
    }
}
