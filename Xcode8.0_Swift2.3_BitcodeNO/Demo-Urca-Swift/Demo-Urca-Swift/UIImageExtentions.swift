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
        CGContextSetRGBFillColor(context, red, green, blue, alpha)
        CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
}
