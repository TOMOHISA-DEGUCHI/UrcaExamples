//
//  ViewControllers.swift
//  CreativeFormat
//
//  Created by TDEGUCHI on 2016/07/25.
//  Copyright © 2016年 MAVERICK.,INC. All rights reserved.
//

import Foundation
import UIKit

/// 画面列挙.
enum Screens: Int, EnumExtension{
    
    case defaultCell
    case customCell
    case collectionView
    case top
    
    /// ナビゲーションバーのタイトルを返す.
    func displayTitle() -> String{
        switch self {
        case .defaultCell:      return "DefaultCell"
        case .customCell:       return "CustomCell"
        case .collectionView:   return "CollectionView"
        case .top:              return "MENU"
        }
    }
    
    /// Storyboard IDを返す.
    func name() -> String{
        switch self {
        case .defaultCell:      return "\(DefaultCellInTableViewController.self)"
        case .customCell:       return "\(CustomCellInTableViewController.self)"
        case .collectionView:   return "\(CollectionViewController.self)"
        case .top:              return "\(ViewController.self)"
        }
    }
    
    /// インスタンスからcase(列挙子)を返す.
    ///
    /// - Parameter screen: インスタンス.
    /// - Returns: case or nil.
    static func instance(of screen: Any) -> Screens? {
        return Screens.cases.filter( { $0.name() == "\(type(of: screen))" }).first
    }

    /// Storyboardのインスタンスを返す.
    func getStoryboard() -> UIStoryboard?{
        switch self{
        case .top:  return UIStoryboard(name: "Main", bundle: nil)
        default:    return UIStoryboard(name: self.name(), bundle: nil)
        }
    }
    
    /// ViewControllerのインスタンスを返す.
    func getViewController() -> UIViewController?{
        let storyboard = getStoryboard()
        return storyboard?.instantiateViewController(withIdentifier: self.name()) ?? nil
    }
}
