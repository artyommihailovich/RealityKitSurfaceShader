//
//  AppDelegate.swift
//  Surface
//
//  Created by Artyom Mihailovich on 10/5/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    lazy var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window?.rootViewController = ARViewController()
        window?.makeKeyAndVisible()
        return true
    }
}

