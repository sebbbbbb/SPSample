//
//  CustomTransitionViewController.swift
//  SPSample
//
//  Created by Sébastien Pécoul on 20/08/2019.
//  Copyright © 2019 Sébastien Pécoul. All rights reserved.
//

import UIKit

class CustomTransitionViewController: UIViewController {
 
  init() {
    super.init(nibName: nil, bundle: nil)
  }
 
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @IBAction func presentNextViewController() {
    let vc = CustomTransitionDestinationViewController()
    vc.transitioningDelegate = self
    vc.modalPresentationStyle = .fullScreen
    present(vc, animated: true, completion: nil)
  }
  
}

extension CustomTransitionViewController: UIViewControllerTransitioningDelegate {
  
  
  
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return AnimationController()
  }
  
}
