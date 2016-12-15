//
//  ViewController.swift
//  Sample-Urca-Swift
//
//  Created by TDEGUCHI on 2016/04/13.
//  Copyright © 2016年 MAVERICK.,INC. All rights reserved.
//

import UIKit
import Urca

/// デモアプリ トップ画面.
class ViewController: UIViewController{
    
    @IBOutlet weak var menuTableView: UITableView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "MENU"
        
        menuTableView.estimatedRowHeight = 44
        menuTableView.rowHeight = UITableViewAutomaticDimension
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
}

extension ViewController{ // UITableView
    /// MARK: UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    /// MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    /// MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        guard let next = Menu(rawValue: indexPath.row) else { return }
        let _next = UIStoryboard(name: next.name(), bundle: nil).instantiateViewControllerWithIdentifier(next.name())
        self.navigationController?.pushViewController(_next, animated: true)
        
    }
    /// MARK: UITableViewDataSource
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = String(indexPath.section) + String(indexPath.row)
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if nil == cell{
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
        }
        
        cell!.textLabel?.text = Menu(rawValue: indexPath.row)?.name() ?? ""
        return cell!
    }
}

enum Menu: Int{
    case defaultCell
    case customCell
    case collectionView
    
    func name() -> String {
        switch self{
        case .defaultCell: return "\(DefaultCellInTableViewController.self)"
        case .customCell: return "\(CustomCellInTableViewController.self)"
        case .collectionView: return "\(CollectionViewController.self)"
        }
    }
}