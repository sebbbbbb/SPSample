//
//  AnimationViewController.swift
//  SPSample
//
//  Created by Sébastien Pécoul on 03/03/2021.
//  Copyright © 2021 Sébastien Pécoul. All rights reserved.
//

import UIKit

class AnimationViewController: UIViewController {
  
  
  @IBOutlet private weak var viewToAnimate1: UIView!
  @IBOutlet private weak var cWidth1: NSLayoutConstraint!
  @IBOutlet private weak var cHeight1: NSLayoutConstraint!
 
  @IBOutlet private weak var viewToAnimate2: UIView!
  @IBOutlet private weak var cWidth2: NSLayoutConstraint!
  @IBOutlet private weak var cHeight2: NSLayoutConstraint!
 
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func animation1() {
    
    cWidth1.constant = 200
    cHeight1.constant = 200
    
    UIView.animate(withDuration: 1.0) {
      self.view.layoutIfNeeded()
    }
  }
  
  @IBAction func animation2() {
    
  }
  

}
