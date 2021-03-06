//
//  CircleView.swift
//  SPSample
//
//  Created by Sébastien Pécoul on 19/11/2020.
//  Copyright © 2020 Sébastien Pécoul. All rights reserved.
//

import UIKit

class CircleView: UIView {
  
  private var shapeLayer = CAShapeLayer()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    
//    let bezierPath = UIBezierPath(
//      arcCenter: CGPoint(x: bounds.width, y: bounds.height),
//      radius: bounds.size.width * 0.5,
//      startAngle: 0,
//      endAngle: 2 * CGFloat.pi,
//      clockwise: true
//    )
//
//    shapeLayer.path = bezierPath.cgPath
    layer.sublayers?.forEach { $0.bounds = layer.bounds }
  }
  
  func setup() {
    
    let bezierPath = UIBezierPath(
      arcCenter: CGPoint(x: bounds.width, y: bounds.height),
      radius: bounds.size.width * 0.5,
      startAngle: 0,
      endAngle: 2 * CGFloat.pi,
      clockwise: true
    )
    
    shapeLayer.path = bezierPath.cgPath
    shapeLayer.strokeColor = UIColor.blue.cgColor
    shapeLayer.fillColor = nil
    shapeLayer.lineWidth = 2.0
    shapeLayer.bounds = bounds
    self.layer.addSublayer(shapeLayer)
  }
}
