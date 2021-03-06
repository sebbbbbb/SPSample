//
//  AppDelegate.swift
//  SPSample
//
//  Created by Sébastien Pécoul on 12/12/2018.
//  Copyright © 2018 Sébastien Pécoul. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow()
    
    // UIKIT
    
    // Other
    
    // audio
    
    // Animation
    
    // Persistence
    
 
    
    window?.rootViewController = UINavigationController(rootViewController: MenuViewController(type: .home))
    window?.makeKeyAndVisible()
    return true
  }
}


protocol MenuView: UIViewController {
  var dataSource: Datasource { get }
}
