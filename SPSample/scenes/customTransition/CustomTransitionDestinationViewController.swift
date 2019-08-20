//
//  CustomTransitionDestinationViewController.swift
//  SPSample
//
//  Created by Sébastien Pécoul on 20/08/2019.
//  Copyright © 2019 Sébastien Pécoul. All rights reserved.
//

import UIKit

class CustomTransitionDestinationViewController: UIViewController {
  
  init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  @IBAction func dismissMe() {
    dismiss(animated: true, completion: nil)
  }
  
}

