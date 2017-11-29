//
//  RestaurantCell.swift
//  FoodList
//
//  Created by 이선협 on 2017. 11. 29..
//  Copyright © 2017년 이선협. All rights reserved.
//

import UIKit

class RestaurantCell: UITableViewCell {
    @IBOutlet var menuImageView: DesignableImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var discountPriceLabel: UILabel!
    @IBOutlet var badgeCollectionView: UICollectionView!
    
    @IBOutlet var discountPriceLabelLeftMargin: NSLayoutConstraint!
    
    var badges: [String] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configure(restaurant: Restaurant) {
        self.menuImageView.image = URL(string: restaurant.image)
            .flatMap { try! Data.init(contentsOf: $0) }
            .flatMap { UIImage(data: $0) }
        self.titleLabel.text = restaurant.title
        self.descriptionLabel.text = restaurant.description
        if let nPrice = restaurant.nPrice {
            self.priceLabel.text = nPrice
            self.priceLabel.isHidden = false
            discountPriceLabelLeftMargin.constant = 10
        } else {
            self.priceLabel.text = ""
            self.priceLabel.isHidden = true
            discountPriceLabelLeftMargin.constant = 0
        }
        self.discountPriceLabel.text = restaurant.sPrice
        if let badges = restaurant.badge {
            self.badges = badges
            self.badgeCollectionView.isHidden = false
        } else {
            self.badgeCollectionView.isHidden = true
        }
        self.badgeCollectionView.reloadData()
    }
}

extension RestaurantCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.badges.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BadgeCell", for: indexPath) as! BadgeCell
        cell.badgeLabel.text = self.badges[indexPath.row]
        cell.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let fontAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 13)]
        let size = (badges[indexPath.row] as NSString).size(attributes: fontAttributes)
        return CGSize(width: size.width + 16, height: size.height + 8)
    }
}
