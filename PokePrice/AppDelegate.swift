//
//  AppDelegate.swift
//  PokePrice
//
//  Created by Bruno on 23/08/26.
//

import UIKit
import FirebaseCore
import FirebaseAnalytics
import FirebaseCrashlytics

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Configure Firebase
        FirebaseApp.configure()
        
        // Initialize Crashlytics
        setupCrashlytics()
        
        // Set up analytics
        setupAnalytics()
        
        // Log app launch
        AnalyticsManager.shared.logScreenView(screenName: "app_launch")
        
        return true
    }
    
    private func setupCrashlytics() {
        // Enable Crashlytics collection
        Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)
        
        // Set up crash reporting for debugging
        #if DEBUG
        Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(false)
        #else
        Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)
        #endif
        
        // Log app version and build
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
           let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            Crashlytics.crashlytics().setCustomValue(appVersion, forKey: "app_version")
            Crashlytics.crashlytics().setCustomValue(buildNumber, forKey: "build_number")
        }
        
        // Log device info
        let deviceModel = UIDevice.current.model
        let systemVersion = UIDevice.current.systemVersion
        Crashlytics.crashlytics().setCustomValue(deviceModel, forKey: "device_model")
        Crashlytics.crashlytics().setCustomValue(systemVersion, forKey: "system_version")
    }
    
    private func setupAnalytics() {
        // Set default analytics parameters
        Analytics.setDefaultEventParameters([
            "app_name": "PokePrice",
            "app_version": Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknown"
        ])
        
        // Enable analytics collection
        Analytics.setAnalyticsCollectionEnabled(true)
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    // MARK: Lifecycle
    
    func applicationWillResignActive(_ application: UIApplication) {
        AnalyticsManager.shared.logScreenView(screenName: "app_background")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        AnalyticsManager.shared.logScreenView(screenName: "app_foreground")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        AnalyticsManager.shared.logScreenView(screenName: "app_terminate")
    }
}