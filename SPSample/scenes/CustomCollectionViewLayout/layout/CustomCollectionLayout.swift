//
//  CustomCollectionLayout.swift
//  SPSample
//
//  Created by Sébastien Pécoul on 04/10/2020.
//  Copyright © 2020 Sébastien Pécoul. All rights reserved.
//

import UIKit

protocol CustomCollectionLayoutDelegate: AnyObject {
  func collectionView(_ collectionView: UICollectionView, sizeForItemAtIndexPath indexPath:IndexPath) -> CGSize
}

class CustomCollectionLayout: UICollectionViewLayout {

  
  weak var delegate: CustomCollectionLayoutDelegate?
  
  let nbColumn = 5
  private let cellPadding: CGFloat = 6
  private var cache: [UICollectionViewLayoutAttributes] = []
  
  private var contentHeight: CGFloat = 0

  private var contentWidth: CGFloat {
    guard let collectionView = collectionView else {
      return 0
    }
    let insets = collectionView.contentInset
    return collectionView.bounds.width - (insets.left + insets.right)
  }

  
  override var collectionViewContentSize: CGSize {
    return CGSize(width: contentWidth, height: contentHeight)
  }
  
  override func prepare() {
    guard
       cache.isEmpty,
       let collectionView = collectionView
       else {
         return
     }
    
    var offsetY: CGFloat = 0
    var offsetX: CGFloat = 0
    
    var columnCpt = 0
    
    for item in 0..<collectionView.numberOfItems(inSection: 0) {
      let indexPath = IndexPath(item: item, section: 0)
      
      let cellSize = delegate!.collectionView(collectionView, sizeForItemAtIndexPath: indexPath)
      let frame = CGRect(x: offsetX, y: offsetY, width: cellSize.width, height: cellSize.height)
      let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
      let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
      
      attributes.frame = insetFrame
      cache.append(attributes)
      contentHeight = max(contentHeight, frame.maxY)
      
     
      
      if columnCpt == nbColumn - 1 {
        offsetX = 0
        offsetY += 108
        columnCpt = 0
      } else {
        columnCpt += 1
        offsetX += 108
      }
    }
    
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
    return visibleLayoutAttributes
  }
  
  
}
