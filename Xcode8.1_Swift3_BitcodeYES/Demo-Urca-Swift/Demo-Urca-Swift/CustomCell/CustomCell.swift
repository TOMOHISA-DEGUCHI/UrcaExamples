//
//  CustomCell.swift
//  Demo-Urca-Swift
//
//  Created by TDEGUCHI on 2016/04/18.
//  Copyright © 2016年 MAVERICK.,INC. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell{
    
    @IBOutlet weak var appImageView: UIImageView!
    @IBOutlet weak var appTitleText: UILabel!
    @IBOutlet weak var appDetailText: UILabel!
    
    deinit{
        print("\(#file) \(#function)")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
