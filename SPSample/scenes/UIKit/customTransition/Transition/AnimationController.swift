//
//  AnimationController.swift
//  SPSample
//
//  Created by Sébastien Pécoul on 20/08/2019.
//  Copyright © 2019 Sébastien Pécoul. All rights reserved.
//

import UIKit

class AnimationController: NSObject, UIViewControllerAnimatedTransitioning /*, CAAnimationDelegate*/ {

  private let animationDuration = 0.400
  
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return self.animationDuration
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    
    guard let fromVC = transitionContext.viewController(forKey: .from),
      let toVC = transitionContext.viewController(forKey: .to),
      let snapshot = fromVC.view.snapshotView(afterScreenUpdates: true) else {
        assert(false, "N'est pas censé arriver : checker les paramètres")
        return
    }
    
    transitionContext.containerView.addSubview(toVC.view)
    //toVC.view.isHidden = true
    fromVC.view.isHidden = true
    
    transitionContext.containerView.addSubview(snapshot)
    
    
    
    UIView.animate(withDuration: self.animationDuration, animations: ({
      snapshot.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
      snapshot.alpha = 0.0
      snapshot.frame = CGRect(x: 0, y: 0, width: fromVC.view.frame.width, height: fromVC.view.frame.height)
    }), completion: ({ _ in
      snapshot.removeFromSuperview()
      toVC.view.isHidden = false
      fromVC.view.isHidden = false
      
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    }))
    
  
  }
  
  /*
 
  private func makeScaleAnimation() -> CABasicAnimation {
    let animation = CABasicAnimation(keyPath: "transform")
    animation.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
    animation.toValue = NSValue(caTransform3D: CATransform3DConcat(
      CATransform3DMakeScale(1.0, 1.0, 1.0),
      CATransform3DMakeScale(15.0, 15.0, 1.0)
    ))
    
    animation.duration = self.animationDuration
    animation.fillMode = kCAFillModeForwards
    animation.isRemovedOnCompletion = true
    animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
    return animation
  }
   */
  
}
