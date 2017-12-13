//
//  AppDelegate.swift
//  Gists
//
//  Created by alex on 06/12/2017.
//  Copyright © 2017 alex. All rights reserved.
//

import UIKit

//@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let loadIndicator = LoadIndicator.mainInstance

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        ObjectFactory.initialize(with: DIContainerBuilder.build())
        
//        observe(Notifications.AuthRequired, with: #selector(onAuthenticationRequired))
        observe(Notifications.UnexpectedApiError, with: #selector(onUnexpectedApiError))
        observe(Notifications.GuardViolation, with: #selector(onGuardViolation))
        observe(Notifications.UnexpectedError, with: #selector(onUnexpectedError))
        
        let mainVC = MainViewController()
        let navController = UINavigationController(rootViewController: mainVC)
        window?.rootViewController = navController
        
        return true
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        let authService = ObjectFactory.get(type: APIAuthServiceProtocol.self)
        authService?.processOAuthStep1Response(url)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func onAuthenticationRequired(notification: Notification) {
//        SecurityContext.invalidate()
//        DispatchQueue.main.async(execute: {
//
//            let store = ObjectFactory.get(type: LocalStore.self)
//            store!.eraseAllData()
//
//            ObjectFactory.initialize(with: DIContainerBuilder.build())
//            AppRouter.showLogin()
//        })
    }
    
    func onUnexpectedApiError(notification: Notification) {
        
        if let error = notification.userInfo!["api_error"] as? ApiRequestError {
            
//            self.errorLogger?.log(source: "ApiClient",
//                                  message: error.description,
//                                  tags: ["API_ERROR"],
//                                  customData: error.getErrorInfoAsDict())
            
            if let controller = self.getCurController(self.window?.rootViewController) {
                let alert = UIAlertController(
                    title: "Error",
                    message: error.description,
                    preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.cancel, handler: nil))
                controller.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func onGuardViolation(notification: Notification) {
//
//        if let userInfo = notification.userInfo,
//            let method = userInfo["method"] as? String,
//            let violation = userInfo["violation"] as? String {
//
//            let sender = String(describing: userInfo["sender"])
//
//            self.errorLogger?.log(source: sender,
//                                  message: "Guard violation at \(sender).\(method) failed: \(violation)",
//                tags: ["GUARD_VIOLATION"],
//                customData: [:])
//        }
    }
    
    func onUnexpectedError(notification: Notification) {
        
//        if let error = notification.userInfo?["error"] as? Error {
//            self.errorLogger?.log(err: error, tags: [], customData: [:])
//        }
    }
    
    func getCurController(_ base: UIViewController?) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getCurController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return getCurController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return getCurController(presented)
        }
        return base
    }
}

