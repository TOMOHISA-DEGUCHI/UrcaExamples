//
//  CollectionViewFlowLayout.swift
//  Demo-Urca-Swift
//
//  Created by TDEGUCHI on 2016/07/08.
//  Copyright © 2016年 MAVERICK.,INC. All rights reserved.
//

import UIKit

class CollectionViewFlowLayout: UICollectionViewFlowLayout{

    override init() {
        super.init()
        sectionInset = UIEdgeInsets(top: 0, left: 1.0, bottom: 1.0, right: 1.0)
        minimumLineSpacing = 2.0
        minimumInteritemSpacing = 1.0
        scrollDirection = .Vertical
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}