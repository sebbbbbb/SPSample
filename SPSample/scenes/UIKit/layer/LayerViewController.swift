//
//  LayerViewController.swift
//  SPSample
//
//  Created by Sebastien on 29/06/2019.
//  Copyright © 2019 Sébastien Pécoul. All rights reserved.
//

import UIKit

// Usefull ressources :
// - https://www.calayer.com/core-animation/2016/05/22/cashapelayer-in-depth.html#what-shape-layers-are
class LayerViewController: UIViewController {
  
  @IBOutlet weak var viewRounded: UIView!
  @IBOutlet weak var viewWithShadowLayer: UIView!
  @IBOutlet weak var viewWithBoth: UIView!
  
  init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
   
    
    // 1 - How to apply rounded corner :
    viewRounded.layer.cornerRadius = 30
    // since iOS11 you can ignore corner to have rounded effect only of top of view for example
    // see : https://developer.apple.com/documentation/quartzcore/cacornermask?utm_source=Little%20Bites%20of%20Cocoa&utm_campaign=5e8e3ea5c8-EMAIL_CAMPAIGN_2017_06_16&utm_medium=email&utm_term=0_2b6df83b4b-5e8e3ea5c8-114264253
   // viewRounded.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]

    // 2 - How to apply a shadow
    
    //Must be false since shadow is drawn outside view bounds
    viewWithShadowLayer.clipsToBounds = false
    viewWithShadowLayer.layer.shadowColor = UIColor.red.cgColor
    viewWithShadowLayer.layer.shadowOffset = CGSize(width: 5, height: 5)
    viewWithShadowLayer.layer.shadowOpacity = 0.5

    
  }
  
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    // 2 Alternative, must be done in viewDidLayoutSubviews to have correct view bounds value
    let shadowLayer = CAShapeLayer()
    shadowLayer.path = UIBezierPath(rect: viewWithShadowLayer.bounds).cgPath
    shadowLayer.fillColor = UIColor.red.cgColor
    shadowLayer.shadowPath = UIBezierPath(rect: viewWithShadowLayer.bounds).cgPath
    shadowLayer.shadowColor = UIColor.black.cgColor
    shadowLayer.shadowOffset = CGSize(width: -5, height: -5)
    shadowLayer.shadowOpacity = 0.5
    viewWithShadowLayer.layer.insertSublayer(shadowLayer, at: 0)
    
    // 3 - Rounded Shadow
    // credits : https://medium.com/bytes-of-bits/swift-tips-adding-rounded-corners-and-shadows-to-a-uiview-691f67b83e4a
    
    let shadowLayer2 = CAShapeLayer()
    shadowLayer2.path = UIBezierPath(roundedRect: viewWithBoth.bounds, cornerRadius: 30.0).cgPath
    // Layer's view must have a clear background color since layer will be drawn on top
    // view background color is determined by the layer and not view
    shadowLayer2.fillColor = UIColor.green.cgColor
    shadowLayer2.shadowRadius = 30.0
    shadowLayer2.shadowPath = UIBezierPath(rect: viewWithBoth.bounds).cgPath
    shadowLayer2.shadowColor = UIColor.black.cgColor
    shadowLayer2.shadowOpacity = 0.8
    viewWithBoth.layer.insertSublayer(shadowLayer2, at: 0)
    //viewWithBoth.clipsToBounds = false
    
  }

}
