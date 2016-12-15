//
//  CustomCollectionViewCell.swift
//  Demo-Urca-Swift
//
//  Created by TDEGUCHI on 2016/07/07.
//  Copyright © 2016年 MAVERICK.,INC. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell{
    
    @IBOutlet weak var appImageView: UIImageView!
    @IBOutlet weak var appTitleText: UILabel!
    @IBOutlet weak var appDateText: UILabel!
    @IBOutlet weak var adLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
