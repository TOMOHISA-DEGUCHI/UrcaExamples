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
        self.navigationItem.title = Screens.instance(of: self)?.displayTitle()
        
        menuTableView.estimatedRowHeight = 44
        menuTableView.rowHeight = UITableViewAutomaticDimension
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

extension ViewController{ // UITableView
    /// MARK: UITableViewDataSource
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 1
    }
    /// MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Screens.count - 1
    }
    /// MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let next = Screens(rawValue: indexPath.row)?.getViewController() else { return }
        self.navigationController?.pushViewController(next, animated: true)
    }
    /// MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cellId = String(indexPath.section) + String(indexPath.row)
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        if nil == cell{
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        }
        cell!.textLabel?.text = Screens(rawValue: indexPath.row)?.displayTitle() ?? ""
        return cell!
    }
}

