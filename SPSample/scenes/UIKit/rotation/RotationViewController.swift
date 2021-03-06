//
//  RotationViewController.swift
//  SPSample
//
//  Created by Sébastien Pécoul on 25/07/2020.
//  Copyright © 2020 Sébastien Pécoul. All rights reserved.
//

import UIKit

/// Usefull links :
/// https://medium.com/@marcosantadev/calayer-and-auto-layout-with-swift-21b2d2b8b9d1
/// https://developer.apple.com/documentation/quartzcore/calayerdelegate/2097257-layoutsublayers
/// https://stackoverflow.com/questions/242424/how-to-rotate-a-layer-view-e-g-just-like-you-would-in-enigmo
class RotationViewController: UIViewController {
  
  @IBOutlet private weak var cImageWidth: NSLayoutConstraint!
 
  /// Call on device rotation
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    // will execute before rotation
    self.cImageWidth.constant = 50
    self.view.layoutIfNeeded()
    
    
    coordinator.animate(alongsideTransition: { context in
      // will execute during rotation
      self.cImageWidth.constant = 200
      self.view.layoutIfNeeded()
    }) { context in
       // will execute after rotation-
    }
  }
}
