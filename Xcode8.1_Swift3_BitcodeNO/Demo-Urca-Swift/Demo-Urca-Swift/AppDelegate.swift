//
//  AppDelegate.swift
//  Urca
//
//  Created by TDEGUCHI on 2016/04/13.
//  Copyright © 2016年 MAVERICK.,INC. All rights reserved.
//

import Urca

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UrcaInfeed {

    var window: UIWindow?
    var navigationController: UINavigationController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let top = Screens.top.getViewController()
        navigationController = UINavigationController(rootViewController: top!)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.setToolbarHidden(true, animated: false)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.addSubview(navigationController!.view)
        window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {}

    func applicationDidEnterBackground(_ application: UIApplication) {
        /// 広告情報破棄.
        let urca = UrcaManager.shared
        urca.clearAd()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {}

    func applicationDidBecomeActive(_ application: UIApplication) {
        
        let urca = UrcaManager.shared
        /// ログ出力 リリース時はfalseでお願いする. デフォルト -> false.
        urca.log(isEnabled: true)
        
        // タブレットで広告を表示したい場合 -> false. デフォルト -> true.
//        urca.disableTablet = false
        
        let request = UrcaRequest()
        request.set(timeout: 3)
//        request.set(InfeedId._A, 1)
//        request.set(InfeedId._B, 1)
//        request.set(InfeedId._C, 1)
//        request.set(InfeedId._D, 1)
//        request.set(InfeedId._E, 1)
        
        request.set(InfeedId._A, 2)
        request.set(InfeedId._B, 2)
        request.set(InfeedId._C, 2)
        request.set(InfeedId._D, 2)
        request.set(InfeedId._E, 2)
        
        urca.loadUrca(by: request, urcaInfeed: self)
    }

    func applicationWillTerminate(_ application: UIApplication) {}
    
    // MARK: UrcaInfeed
    func successfulToReceived(at count: Int) {
        print(#function)
        print("success \(count)")
    }
    
    // MARK: UrcaInfeed
    func failedToReceived(with error: NSError?) {
        print(#function)
        print(error ?? "nil")
    }
}
