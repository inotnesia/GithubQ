//
//  AppDelegate.swift
//  GithubQ
//
//  Created by Tony Hadisiswanto on 15/11/20.
//  Copyright © 2020 inotnesia. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let searchModule = SearchModule()
        let navigationController = UINavigationController(rootViewController: searchModule.view)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        return true
    }
}

