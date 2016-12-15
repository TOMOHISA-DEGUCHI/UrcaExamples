//
//  CollectionViewController.swift
//  Demo-Urca-Swift
//
//  Created by TDEGUCHI on 2016/07/06.
//  Copyright © 2016年 MAVERICK.,INC. All rights reserved.
//

import UIKit
import Urca

class CollectionViewController: UICollectionViewController{
    
    /// アプリのデータソース.
    var dataSource = [Any]()
    var urca: UrcaManager?
    /// セルの数.
    var total = 0
    /// セルのサイズ.
    var cellSize: CGSize = CGSize.zero
    
    var image: UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        urca = UrcaManager.shared
        let newData = makeDataSource(of: 28)
        dataSource = mergeAd(and: newData)
        
        let layout = CollectionViewFlowLayout()
        let side = (UIScreen.mainScreen().bounds.size.width / 2) - 2
        cellSize = CGSize(width: side, height: side)
        image = UIImage.makeImage(CGSize(width: side, height: side), red: 0,
                                  green: 255,
                                  blue: 255,
                                  alpha: 1.0)
        layout.itemSize = cellSize
        collectionView?.collectionViewLayout = layout
        collectionView?.pagingEnabled = false
    }
}


/// MARK: UICollectionViewDataSource
extension CollectionViewController {
    
    // セクションの数
    /// MARK: UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    // セクション内の行数. required
    /// MARK: UICollectionViewDataSource
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    // セルの生成. required
    /// MARK: UICollectionViewDataSource
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cellId = "cell"
        let rowData = dataSource[indexPath.item]
        if rowData is UrcaAdInfo{
            cellId = (rowData as! UrcaAdInfo).uuid
        }
        
        let nib = UINib(nibName: "\(CustomCollectionViewCell.self)", bundle: nil)
        collectionView.registerNib(nib, forCellWithReuseIdentifier: cellId)
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            cellId, forIndexPath: indexPath) as? CustomCollectionViewCell else {
            fatalError()
        }
        
        // 広告
        if rowData is UrcaAdInfo {
            
            let data: UrcaAdInfo = rowData as! UrcaAdInfo
            urca?.setInfeed(to: cell,
                            adInfo: data,
                            imageView: cell.appImageView,
                            titleLabel: cell.appTitleText,
                            descriptionLabel: nil,
                            advertiserLabel: cell.appDateText,
                            adLabel: cell.adLabel,
                            size: cellSize)
        }
        
        // アプリ
        if rowData is SampleDataModel {
            
            let data: SampleDataModel = rowData as! SampleDataModel
            cell.appImageView.image = image
            cell.appTitleText.text = data.title
            cell.appDateText.text = data.detail
        }
        return cell
    }
}


/// MARK: UICollectionViewDelegate
extension CollectionViewController{
    
    /// MARK: UICollectionViewDelegate
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // cellForItemAtIndexPathの直前.
    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        urca?.tryImpression(at: cell, from: #function)
    }
}


extension CollectionViewController {
    /// データソースを生成して返す.
    ///
    /// - Parameter count: 生成するデータソースの件数.
    /// - Returns: 生成したデータソース.
    func makeDataSource(of count: Int) -> [Any]{
        
        var result = [Any]()
        if 1 > count { return result }
        
        (0..<count).forEach({_ in
            total += 1
            var data = SampleDataModel()
            data.title = "タイトル\(total)"
            data.detail = "詳細テキスト\(total)"
            result.append(data)
        })
        return result
    }
    
    /// データソースに広告情報をマージ.
    ///
    /// - Parameter newData: データソース.
    /// - Returns: データソースと広告情報をマージした配列.
    func mergeAd(and newData: [Any]) -> [Any]{
        
        guard let urca = urca else{ return newData }
        var result = newData
        if let ad = urca.hasNextAd(for: InfeedId._A) { // インフィードIDを指定して広告情報を取得.
            result.insert(ad, atIndex: 6)
        }
        if let ad = urca.hasNextAd(for: InfeedId._B) { // インフィードIDを指定して広告情報を取得.
            result.insert(ad, atIndex: 12)
        }
        return result
    }
}
