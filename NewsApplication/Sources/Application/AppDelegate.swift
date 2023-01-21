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
        let nc = DefaultNetworkClient()
        let presenter = NewsMainPresenter(networkService: nc)
        let vc = NewsMainViewController(presenter: presenter)
        presenter.view = vc
        let navigationController = UINavigationController(rootViewController: vc)
        window?.rootViewController = navigationController
        window?.overrideUserInterfaceStyle = .unspecified
        window?.makeKeyAndVisible()
        return true
    }



}

