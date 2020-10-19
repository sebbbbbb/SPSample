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
      layout.scrollDirection = .horizontal
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

extension CoverflowViewController: UICollectionViewDelegateFlowLayout {
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
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
  
}

// MARK: -

final class CoverFlowLayout: UICollectionViewFlowLayout {
  
  override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    //debugPrint(super.layoutAttributesForItem(at: indexPath))
    return super.layoutAttributesForItem(at: indexPath)
  }
  
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    //debugPrint(super.layoutAttributesForElements(in: rect))
    return super.layoutAttributesForElements(in: rect)
  }
  
  
}
