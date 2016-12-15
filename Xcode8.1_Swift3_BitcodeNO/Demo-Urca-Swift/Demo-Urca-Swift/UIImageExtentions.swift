//
//  UIImageExtentions.swift
//  Demo-Urca-Swift
//
//  Created by TDEGUCHI on 2016/12/05.
//  Copyright © 2016年 MAVERICK.,INC. All rights reserved.
//

import UIKit

extension UIImage{
    
    /// UIImageを返す.
    ///
    /// - サイズと色(RGBA)を指定.
    ///
    /// - Parameters:
    ///   - size: 生成するUIImageのサイズ.
    ///   - red:
    ///   - green:
    ///   - blue:
    ///   - alpha:
    ///   - Returns: UIImage.
    static func makeImage(size: CGSize, red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIImage?{
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.setFillColor(red: red, green: green, blue: blue, alpha: alpha)
        context.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
}
