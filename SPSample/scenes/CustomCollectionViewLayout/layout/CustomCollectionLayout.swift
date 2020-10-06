//
//  CustomCollectionLayout.swift
//  SPSample
//
//  Created by Sébastien Pécoul on 04/10/2020.
//  Copyright © 2020 Sébastien Pécoul. All rights reserved.
//

import UIKit

protocol CustomCollectionLayoutDelegate: AnyObject {
  func associatedGrid() -> Grid
  func regenerateGrid()
  
}

class CustomCollectionLayout: UICollectionViewLayout {
  
  
  weak var delegate: CustomCollectionLayoutDelegate?
  
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
      let _ = collectionView
      else {
        return
    }
    
    cache.removeAll()
    
    
    
    debugPrint("⚠️ B")
    
    var offsetY: CGFloat = 0
    var offsetX: CGFloat = 0
   
    let grid = delegate!.associatedGrid()
    var itemCpt = 0
    for gridItem in grid.items {
      switch gridItem {
      case .placeHolder:
        updateOffsets(offsetX: &offsetX, offsetY: &offsetY)
      case .cell(let cell):
        let size = cell.size()
        let indexPath = IndexPath(item: itemCpt, section: 0)
        let frame = CGRect(x: offsetX, y: offsetY, width: size.width, height: size.height)
        let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = insetFrame
        itemCpt += 1
        cache.append(attributes)
        contentHeight = max(contentHeight, frame.maxY)
        updateOffsets(offsetX: &offsetX, offsetY: &offsetY)
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
    
  // MARK: - Private
  
  func updateOffsets(offsetX: inout CGFloat,offsetY: inout CGFloat) {
    let nbColumn = delegate!.associatedGrid().columnNb
    if offsetX >= (Cell.square.size().width + cellPadding) * CGFloat(nbColumn - 1) {
      offsetX = 0
      offsetY += 100 + cellPadding
    }  else {
      offsetX += 100 + cellPadding
    }
  }
  
}
