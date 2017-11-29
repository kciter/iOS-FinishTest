//
//  SectionHeaderCell.swift
//  FoodList
//
//  Created by 이선협 on 2017. 11. 29..
//  Copyright © 2017년 이선협. All rights reserved.
//

import UIKit

class SectionHeaderCell: UITableViewCell {
    @IBOutlet var badgeLabel: UILabel! {
        didSet {
            self.labelWidth?.constant = badgeLabel.frame.size.width + 16
        }
    }
    @IBOutlet var descriptionLabel: UILabel!
    
    @IBOutlet var labelWidth: NSLayoutConstraint?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
