//
//  InfiniteScrollViewController.swift
//  SPSample
//
//  Created by Sébastien Pécoul on 05/03/2021.
//  Copyright © 2021 Sébastien Pécoul. All rights reserved.
//

import UIKit

enum ScrollDirection {
  case left
  case right
}


class InfiniteScrollViewController: UIViewController {
  
  var square1: UIView!
  var square2: UIView!
  var square3: UIView!
  var square4: UIView!
  
  let itemCount: CGFloat = 4
  let itemMargin: CGFloat = 16.0
  let itemWidth: CGFloat = 140
  var scrollDirection: ScrollDirection = .right
  var lastScrollPosition: CGPoint = .zero {
    willSet {
      scrollDirection = newValue.x >= lastScrollPosition.x ? .right : .left
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupLayout()
  }
  
  
  // MARK: Layout
  
  private func setupLayout() {
    
    view.backgroundColor = .white
    
    let scrollView = UIScrollView()
    scrollView.backgroundColor = .gray
    scrollView.delegate = self
    view.addSubview(scrollView)
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200.0).isActive = true
    scrollView.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
    
    
    let contentView = UIView()
    scrollView.addSubview(contentView)
    contentView.translatesAutoresizingMaskIntoConstraints = false
   
    let itemCount: CGFloat = 4
    let itemMargin: CGFloat = 16.0
    let itemWidth: CGFloat = 100
    _ = itemWidth * itemCount + itemMargin * ( itemCount + 1)
    
    contentView.widthAnchor.constraint(equalToConstant: 999_999).isActive = true
    contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
    contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
    contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
    
    
    self.square1 = makeSquareView(with: .red)
    contentView.addSubview(square1)
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 25))
    label.text = "1"
    square1.addSubview(label)
    square1.center = CGPoint(x: itemWidth * 1/2 + itemMargin, y: 25)
    
    self.square2 = makeSquareView(with: .blue)
    contentView.addSubview(square2)
    let label2 = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 25))
    label2.text = "2"
    
    square2.addSubview(label2)
    square2.center = CGPoint(x: square1.center.x + itemWidth * 1/2 + itemMargin * 4, y: 25)
    
    self.square3 = makeSquareView(with: .green)
    contentView.addSubview(square3)
    square3.center = CGPoint(x: square2.center.x + itemWidth * 1/2 + itemMargin  * 4, y: 25)
    let label3 = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 25))
    label3.text = "3"
    
    square3.addSubview(label3)
    
    self.square4 = makeSquareView(with: .orange)
    contentView.addSubview(square4)
    square4.center = CGPoint(x: square3.center.x + itemWidth * 1/2 + itemMargin  * 4, y: 25)
    let label4 = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 25))
    label4.text = "4"
    square4.addSubview(label4)
  }
  
  
  private func makeSquareView(with color: UIColor) -> UIView {
    let squareView = UIView()
    squareView.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
    squareView.backgroundColor = color
    return squareView
  }
}

extension InfiniteScrollViewController: UIScrollViewDelegate {
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
    if scrollView.contentOffset.y < 0 { return }
    lastScrollPosition = scrollView.contentOffset
    
    debugPrint("Scroll Direction :\(scrollDirection)")
    
    // Scrolling --->
    
    switch scrollDirection {
    case .left:
      handleScrollLeft(scrollView: scrollView)
    case .right:
      handleScrollRight(scrollView: scrollView)
    }
    
    // Scrolling <---
    
  }
  
  func handleScrollLeft(scrollView: UIScrollView) {

    // Square 4
    if abs(square4.center.x - scrollView.bounds.origin.x) < 100  {
      square3.center = CGPoint(x: square4.center.x - itemWidth + itemMargin, y: 25)
    }
    
    if abs(square3.center.x - scrollView.bounds.origin.x) < 100  {
      square2.center = CGPoint(x: square3.center.x - itemWidth + itemMargin, y: 25)
    }
    
    
    if abs(square2.center.x - scrollView.bounds.origin.x) < 100  {
      square1.center = CGPoint(x: square2.center.x - itemWidth + itemMargin, y: 25)
    }
    
    
    if abs(square1.center.x - scrollView.bounds.origin.x) < 100  {
      square4.center = CGPoint(x: square1.center.x - itemWidth + itemMargin, y: 25)
    }
    
    
    debugPrint("Bounds : \(scrollView.bounds)")
    debugPrint("Center: \(square4.center.x)")
  }
  
  func handleScrollRight(scrollView: UIScrollView) {
    // Square 1
    if square1.frame.intersects(scrollView.bounds) && square1.center.x <= square2.center.x {
     
    } else {
      square1.center = CGPoint(x: square4.center.x + itemWidth * 1/2 + itemMargin  * 4.0, y: 25)
    }
    
    // Square 2
    if square2.frame.intersects(scrollView.bounds) && square2.center.x <= square3.center.x {
     
    } else {
      square2.center = CGPoint(x: square1.center.x + itemWidth * 1/2 + itemMargin  * 4.0, y: 25)
    }
    
    // Square 3
    if square3.frame.intersects(scrollView.bounds) && square3.center.x <= square4.center.x {
     
    } else {
      square3.center = CGPoint(x: square2.center.x + itemWidth * 1/2 + itemMargin  * 4.0, y: 25)
    }
    
    // Square 4
    if square4.frame.intersects(scrollView.bounds) && square4.center.x <= square1.center.x {
     
    } else {
      square4.center = CGPoint(x: square3.center.x + itemWidth * 1/2 + itemMargin  * 4.0, y: 25)
    }
    
  }
  
}
