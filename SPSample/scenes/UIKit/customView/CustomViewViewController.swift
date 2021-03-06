//
//  CustomViewViewController.swift
//  SPSample
//
//  Created by Sébastien Pécoul on 19/11/2020.
//  Copyright © 2020 Sébastien Pécoul. All rights reserved.
//

import UIKit

class CustomViewViewController: UIViewController {
  
  
  @IBOutlet private weak var cCircleWidth: NSLayoutConstraint!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  
  @IBAction func resizeCircle() {
    UIView.animate(withDuration: 2.5) { [self] in
      cCircleWidth.constant = 40
      view.layoutIfNeeded()
    }
 
  }
}
