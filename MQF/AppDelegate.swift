//
//  AppDelegate.swift
//  MQF
//
//  Created by Christian Brechbuhl on 5/25/19.


import UIKit

@UIApplicationMain

/// Entry point for the app
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let uiTesting = ProcessInfo.processInfo.arguments.contains("ui-testing")
        let uiTestingSetup = ProcessInfo.processInfo.arguments.contains("ui-testing-setup")
        
        print("App Started with Arguments :\(ProcessInfo.processInfo.arguments)")
        //If ui testing the set up, reset user selections
        if(uiTestingSetup){
            //        MQFDefaults().set(false, forKey: MQFDefaults.hasBeenSetup)
            //        MQFDefaults().set("NONECHOSEN", forKey: MQFDefaults.activePresetID)
            //        MQFDefaults().set("PRESET", forKey: MQFDefaults.activeMode)
            //        MQFDefaults().set("OGV Presets", forKey: MQFDefaults.pickerMode)
            MQFDefaults().removeObject(forKey: MQFDefaults.hasBeenSetup)
            MQFDefaults().removeObject(forKey: MQFDefaults.activePresetID)
            MQFDefaults().removeObject(forKey: MQFDefaults.activeMode)
            MQFDefaults().removeObject(forKey: MQFDefaults.pickerMode)
            MQFDefaults().removeObject(forKey: MQFDefaults.crewPosition)
            
            MQFDefaults().synchronize()
        }else if(uiTesting){
            MQFDefaults().set(true, forKey: MQFDefaults.hasBeenSetup)
            MQFDefaults().set("KCHS-Pilot-Airland", forKey: MQFDefaults.activePresetID)
            MQFDefaults().set("PRESET", forKey: MQFDefaults.activeMode)
            MQFDefaults().set("OGV Presets", forKey: MQFDefaults.pickerMode)
            MQFDefaults().set("C-17", forKey: MQFDefaults.mds)
            MQFDefaults().synchronize()
            
        }
        DataManager.shared.load()
        
        
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
    
    
}

