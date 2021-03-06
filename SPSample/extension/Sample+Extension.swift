//
//  Sample+Extension.swift
//  SPSample
//
//  Created by Sébastien Pécoul on 20/02/2021.
//  Copyright © 2021 Sébastien Pécoul. All rights reserved.
//

import UIKit

extension UIApplication {
  
  /// Return current UIViewController
  /// ⚠️ If you use this helper on coordinator unit test make sure they are added in the view hierachy otherwise
  /// this method will return a wrong controller
  static func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
    if let nav = base as? UINavigationController {
      return topViewController(base: nav.visibleViewController)
    }
    if let presented = base?.presentedViewController {
      return topViewController(base: presented)
    }
    if let tabBar = base as? UITabBarController {
      if let selected = tabBar.selectedViewController {
        return topViewController(base: selected)
      }
    }
    return base
  }
  
  /// Return current Navigation Controller
  /// ⚠️ If you use this helper on coordinator unit test make sure they are added in the view hierachy otherwise
  /// this method will return a wrong controller
  static func topNavigationController() -> UINavigationController {
    return topViewController()!.navigationController!
  }
}

