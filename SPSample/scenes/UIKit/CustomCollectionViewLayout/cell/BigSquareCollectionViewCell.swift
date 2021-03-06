//
//  BigSquareCollectionViewCell.swift
//  SPSample
//
//  Created by Sébastien Pécoul on 04/10/2020.
//  Copyright © 2020 Sébastien Pécoul. All rights reserved.
//

import Reusable
import UIKit

class BigSquareCollectionViewCell: UICollectionViewCell, NibReusable {
  
  static var size: CGSize {
    if UIApplication.shared.statusBarOrientation.isLandscape {
      return CGSize(width: 316, height: 316)
    } else {
      return CGSize(width: 208, height: 208)
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    backgroundColor = .darkGray
  }
  
}
