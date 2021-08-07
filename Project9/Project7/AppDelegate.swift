//
//  AppDelegate.swift
//  Project7
//
//  Created by out-usacheva-ei on 31.07.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UIWindowSceneDelegate {

//    var window: UIWindow?
    
//      This gets called by iOS when the app has finished loading and is ready to be used.
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//      THIS METHOD FOR OLD VERSIONS OF iOS
//      FOR NEW LOCATED IN SceneDelegate
        
//      Root view controller is a UITabBarController.
//        if let tabBarController = window?.rootViewController as? UITabBarController {
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "NavController")
//            vc.tabBarItem = UITabBarItem(tabBarSystemItem: .topRated, tag: 1)
//            tabBarController.viewControllers?.append(vc)
//        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

