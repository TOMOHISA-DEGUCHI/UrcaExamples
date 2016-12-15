//
//  CustomCellInTableViewController.swift
//  Demo-Urca-Swift
//
//  Created by TDEGUCHI on 2016/04/13.
//  Copyright © 2016年 MAVERICK.,INC. All rights reserved.
//
import UIKit
import Urca

/// デモ UITableViewController カスタムセル(UITableViewCellのサブクラス).
class CustomCellInTableViewController: UITableViewController{
    
    /// アプリのデータソース.
    var dataSource = [Any]()
    var urca: UrcaManager?
    /// セルの高さ.
    var cellHeight: CGFloat = 101
    /// テーブルビューの行数.
    var total = 0
    
    lazy var image: UIImage? = {
        return UIImage.makeImage(size: CGSize(width: 100, height: 100), red: 0,
                                                                      green: 255,
                                                                       blue: 255,
                                                                      alpha: 1.0)
        }()
    
    deinit{
        print("\(#file) \(#function)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = Screens.instance(of: self)?.displayTitle()
        
        urca = UrcaManager.shared
        let newData = makeDataSource(of: 48)
        dataSource = mergeAd(and: newData)
    }
    
    /// MARK: UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    /// MARK: UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    /// MARK: UITableViewDelegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    /// MARK: UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true, completion: nil)
    }

    
    /// MARK: UITableViewDataSource
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cellId = "cell"
        let rowData = dataSource[indexPath.row]
        if rowData is UrcaAdInfo{
            cellId = (rowData as! UrcaAdInfo).uuid
        }
        
        let nib = UINib(nibName: "\(CustomCell.self)", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? CustomCell else{
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
                 advertiserLabel: cell.appDetailText,
                         adLabel: nil,
                          height: cellHeight)
        }
        
        // アプリ
        if rowData is SampleDataModel {
            
            let data: SampleDataModel = rowData as! SampleDataModel
            
            cell.appTitleText.text = data.title
            cell.appDetailText.text = data.detail
            cell.appImageView.image = image
        }
        
        return cell
    }
}


extension CustomCellInTableViewController{
    
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
            result.insert(ad, at: 6)
        }
        if let ad = urca.hasNextAd(for: InfeedId._B) { // インフィードIDを指定して広告情報を取得.
            result.insert(ad, at: 12)
        }
        return result
    }
}

// ボトムで追加
extension CustomCellInTableViewController{
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        urca?.tryImpression(at: cell, from: #function)
        if dataSource.count == indexPath.row + 1{
            loadMore()
            tableView.reloadData()
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    
    /// ボトムで追加するデータを生成.
    func loadMore(){
        let newData = makeDataSource(of: 18)
        let _ = mergeAd(and: newData).flatMap({ [weak self] in
            self?.dataSource.append($0)
        })
    }
}
