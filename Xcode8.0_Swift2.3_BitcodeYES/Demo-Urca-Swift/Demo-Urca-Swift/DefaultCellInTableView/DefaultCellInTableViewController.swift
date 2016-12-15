//
//  DefaultCellInTableViewController.swift
//  Demo-Urca-Swift
//
//  Created by TDEGUCHI on 2016/04/13.
//  Copyright © 2016年 MAVERICK.,INC. All rights reserved.
//

import UIKit
import Urca

/// デモ UITableViewController  非カスタムセル(UITableViewCell).
class DefaultCellInTableViewController: UITableViewController, UrcaInfeed{
    
    /// アプリのデータソース.
    var dataSource = [Any]()
    var urca: UrcaManager?
    /// セルの高さ.
    var cellHeight: CGFloat = 100
    /// テーブルビューの行数.
    var total = 0
    /// 広告画像のサイズ.
    var imageSize: CGSize = CGSize(width: 50, height: 50)
    lazy var image: UIImage? = {
        return UIImage.makeImage(CGSize(width: 50, height: 50), red: 0,
                                 green: 255,
                                 blue: 255,
                                 alpha: 1.0)
    }()
    
    deinit{
        print("\(#file) \(#function)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        urca = UrcaManager.shared
        let request = UrcaRequest()
        request.set(timeout: 3)
        request.set(InfeedId._A, 1)
        request.set(InfeedId._B, 1)
        
        urca?.loadUrca(by: request, urcaInfeed: self)
    }
    
    func setup(){
        
        let newData = makeDataSource(of: 20)
        dataSource = mergeAd(and: newData)
        tableView.reloadData()
        tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Top, animated: false)
        
    }
    
    func successfulToReceived(at count: Int) {
        print(#function)
        print("success \(count)")
        dispatch_async(dispatch_get_main_queue(), {
            self.setup()
        })
    }
    
    func failedToReceived(with error: NSError?) {
        print(#function)
        print(error ?? "nil")
        dispatch_async(dispatch_get_main_queue(), {
            self.setup()
        })
    }
    
    // MARK: UITableViewDataSource
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    // MARK: UITableViewDataSource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    // MARK: UITableViewDelegate
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cellHeight
    }
    // MARK: UITableViewDelegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: UITableViewDataSource
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cellId = "cell"
        let rowData = dataSource[indexPath.row]
        if rowData is UrcaAdInfo{
            cellId = (rowData as! UrcaAdInfo).uuid
        }
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if nil == cell{
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
        }
        
        // 広告
        if rowData is UrcaAdInfo {
            let data: UrcaAdInfo = rowData as! UrcaAdInfo
            urca?.setInfeed(to: cell!, adInfo: data, height: cellHeight, imageSize: imageSize)
        }
        
        // アプリ面
        if rowData is SampleDataModel {
            let data: SampleDataModel = rowData as! SampleDataModel
            cell?.textLabel?.text = data.title
            cell?.detailTextLabel?.text = data.detail
            cell?.imageView?.image = image
        }
        
        return cell!
    }
}


extension DefaultCellInTableViewController{
    
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
            result.insert(ad, atIndex: 10)
        }
        if let ad = urca.hasNextAd(for: InfeedId._B) { // インフィードIDを指定して広告情報を取得.
            result.insert(ad, atIndex: result.endIndex)
        }
        return result
    }
}
    
// テーブルビューのボトムで行を追加
extension DefaultCellInTableViewController{
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        urca?.tryImpression(at: cell, from: #function)
        if dataSource.count == indexPath.row + 1{
            loadMore()
            tableView.reloadData()
            tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
        }
    }
    
    /// ボトムで追加するデータを生成.
    func loadMore(){
        let newData = makeDataSource(of: 20)
        let _ = mergeAd(and: newData).flatMap({ [weak self] in
            self?.dataSource.append($0)
            })
    }
}
