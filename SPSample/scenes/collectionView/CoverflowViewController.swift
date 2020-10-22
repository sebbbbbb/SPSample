//
//  CoverflowViewController.swift
//  SPSample
//
//  Created by Sébastien Pécoul on 16/10/2020.
//  Copyright © 2020 Sébastien Pécoul. All rights reserved.
//

import Reusable
import UIKit

class CoverflowViewController: UIViewController {
  
  @IBOutlet private weak var collectionView: UICollectionView!
  
  init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let layout = collectionView?.collectionViewLayout as? CoverFlowLayout {
     // layout.scrollDirection = .horizontal
    }
      
    collectionView.register(cellType: BigSquareCollectionViewCell.self)
  }
  
}

extension CoverflowViewController: UICollectionViewDataSource {
  
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    return collectionView.dequeueReusableCell(for: indexPath) as BigSquareCollectionViewCell
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 10
  }
}

extension CoverflowViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
    return
    
    let contentOffset = scrollView.contentOffset
    let visibleCells = collectionView.visibleCells
    
    debugPrint("📝  Offset : \(contentOffset.x)")
    
    for i in 0..<visibleCells.count {
      debugPrint("📝  \(i) \(visibleCells[i].frame)")
      debugPrint("📝  \(i) \(visibleCells[i].center.x)")
    }
    
    let centerX = collectionView.center.x
    var i = 0
    visibleCells.forEach { visibleCell in
      
      let realCenter = abs((visibleCell.center.x - contentOffset.x) - UIScreen.main.bounds.width  * 0.5)
      let ratio = 0.05 * abs(1 - realCenter / (UIScreen.main.bounds.width  * 0.5))
      
      // Don't apply zoom for first cell
      if realCenter <= UIScreen.main.bounds.width * 0.5 && visibleCell.frame.origin.x != 0 {
        visibleCell.transform =  CGAffineTransform(scaleX: 1 + ratio, y: 1 + 2 * ratio)
      } else {
        visibleCell.transform =  CGAffineTransform.identity
      }
      
      debugPrint("📝 REAL CENTER \(i) \(realCenter)")
      debugPrint("📝 Zoom ratio \(i) \(ratio)")
      
      i += 1
    }
    
    
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 300, height: 400)
  }
  
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 16.0
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    debugPrint("Selected index : \(indexPath)")
  }

}

// MARK: -

final class CoverFlowLayout: UICollectionViewLayout {
  
  
  private var cache = [UICollectionViewLayoutAttributes]()
  private var contentHeight: CGFloat = 0
  private var contentWidth: CGFloat = 0
  
  override var collectionViewContentSize: CGSize {
    return CGSize(width: contentWidth, height: contentHeight)
  }
  
  override func prepare() {
    guard
      let collectionView = collectionView
      else {
        return
    }
    
    let contentOffsetX = collectionView.contentOffset.x
    var offsetX: CGFloat = 16.0
    var offsetY: CGFloat = 16.0
    
    cache.removeAll()
    
    //hardcoded value Because i'm lazy
    for i in 0...10 {
      let indexPath = IndexPath(row: i, section: 0)
      
      
      let frame = CGRect(x: offsetX, y: offsetY, width: 300, height: 400)
      let isCellOnScreen = CGRect(x: contentOffsetX, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height).contains(CGPoint(x: offsetX + frame.size.width * 0.5, y: frame.size.height * 0.5))
     
      let insetFrame = frame.insetBy(dx: 8, dy: 8)
      let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
      attributes.frame = insetFrame
      
      if isCellOnScreen {
        let realCenter = abs((offsetX + frame.size.width * 0.5 - contentOffsetX) - UIScreen.main.bounds.width  * 0.5)
        let ratio = 0.05 * abs(1 - realCenter / (UIScreen.main.bounds.width  * 0.5))
        attributes.transform = CGAffineTransform(scaleX: 1 + ratio, y: 1 + 2 * ratio)
      }
      
      offsetX += 300
      cache.append(attributes)
      contentHeight = max(contentHeight, frame.maxY)
      contentWidth = max(contentWidth, frame.maxX)
    }
  }
  
  override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    debugPrint("Invalidate")
    return true
  }
  
  
  override func layoutAttributesForElements(in rect: CGRect)
    -> [UICollectionViewLayoutAttributes]? {
      var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
      
      // Loop through the cache and look for items in the rect
      for attributes in cache {
        if attributes.frame.intersects(rect) {
          visibleLayoutAttributes.append(attributes)
        }
      }
      
      debugPrint("Layout attributes \(rect)")
      debugPrint("Layout attributes \(visibleLayoutAttributes.count)")
      return visibleLayoutAttributes
  }
  
  override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    return cache[indexPath.item]
  }
  
}
