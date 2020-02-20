//
//  AppDelegate.swift
//  GoraStudioTestProject
//
//  Created by Kirill Fedorov on 18.02.2020.
//  Copyright © 2020 Kirill Fedorov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.rootViewController = UINavigationController(rootViewController: Factory().createUsersModule())
		window?.makeKeyAndVisible()
		return true
	}
}

