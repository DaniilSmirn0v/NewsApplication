//
//  AppDelegate.swift
//  NewsApplication
//
//  Created by Даниил Смирнов on 17.01.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = window else { return false }
        
        let networkMonitor = NetworkMonitor.shared
        networkMonitor.startMonitoring()

        setup(window)
    
        return true
    }
    
    private func setup(_ window: UIWindow) {
        let navigationController = UINavigationController()
        let router = NewsMainRouter(navigationController: navigationController)
        router.initialViewController()
        
        window.rootViewController = navigationController
        window.overrideUserInterfaceStyle = .light
        window.makeKeyAndVisible()
    }
}

