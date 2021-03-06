//
//  ProgressViewController.swift
//  SPSample
//
//  Created by Sébastien Pécoul on 25/05/2020.
//  Copyright © 2020 Sébastien Pécoul. All rights reserved.
//

import UIKit

class ProgressViewController: UIViewController {

  @IBOutlet private weak var viewProgress: UIView!
  
  init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Circular progress view"
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    setupLayer(value: 0.0)
  
 
    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
      self.setupLayer(value: 1.0)
    }
  
  }
  
  // MARK: - Private
  
  func setupLayer(value: CGFloat) {
    
    viewProgress.layer.sublayers?.removeAll()
    
    let convertedValue = value * 2 * CGFloat.pi - 1/2 * CGFloat.pi
    
    let layer = CAShapeLayer()
    let path = UIBezierPath()
    path.addArc(withCenter: viewProgress.center, radius: 100, startAngle: -1/2 * CGFloat.pi, endAngle: convertedValue, clockwise: true)
  
    
   
    layer.path = path.cgPath
    
    let animation = CABasicAnimation(keyPath: "strokeEnd")
    animation.fromValue = 0
    animation.duration = 0.450
    layer.add(animation, forKey: "MyAnimation")
    
  
    
    layer.borderColor = UIColor.red.cgColor
    layer.strokeColor = UIColor.red.cgColor
    layer.fillColor = UIColor.white.cgColor
    layer.lineWidth = 8.0
    layer.bounds = viewProgress.bounds
    viewProgress.layer.addSublayer(layer)
  }
}
