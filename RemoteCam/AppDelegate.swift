//
//  AppDelegate.swift
//  RemoteCam
//
//  Created by Dario Lencina on 10/31/15.
//  Copyright © 2015 dario. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        InAppPurchasesManager.shared().reloadProducts { (i, e) in }
        application.statusBarStyle = .lightContent
        self.setCustomNavBarTheme()
        return true
    }
    
    func setCustomNavBarTheme() {
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.black
        shadow.shadowOffset = CGSize.init(width: 0.0, height: 1.0)
        
        let app = UINavigationBar.appearance()

        app.setBackgroundImage(UIImage(named:"blueBar"), for: .default)
        let atts = [
            NSForegroundColorAttributeName : UIColor.white,
            NSShadowAttributeName : shadow
        ]

        app.titleTextAttributes = atts
        
        let buttonApp = UIBarButtonItem.appearance()
        buttonApp.setTitleTextAttributes(atts, for: .normal)
        buttonApp.setBackgroundImage(UIImage(named:"navigationBarButton"), for: .normal, barMetrics: .default)
        
        
        let backButtonPressed = UIImage(named:"navigationBarBack")
        let _backButtonPressed = backButtonPressed!.resizableImage(withCapInsets: UIEdgeInsetsMake(0, 14, 0, 4))
        
        buttonApp.setBackButtonBackgroundImage(_backButtonPressed, for: .normal, barMetrics: .default)
        
    }


    func applicationWillResignActive(_ application: UIApplication) {}

    func applicationDidEnterBackground(_ application: UIApplication) {}

    func applicationWillEnterForeground(_ application: UIApplication) {}

    func applicationDidBecomeActive(_ application: UIApplication) {}

    func applicationWillTerminate(_ application: UIApplication) {}

}

