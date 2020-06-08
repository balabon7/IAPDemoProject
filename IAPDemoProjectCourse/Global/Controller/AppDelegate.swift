//
//  AppDelegate.swift
//  IAPDemoProject
//
//  Created by Ivan Akulov on 26/10/2017.
//  Copyright © 2017 Ivan Akulov. All rights reserved.
//

import UIKit
import StoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Добавляем нашего менеджера в качестве наблюдателя
        IAPManager.shared.setupPurchases { success in
            if success {
           //     IAPManager.shared.
            }
        }
        
        return true
    }
}

