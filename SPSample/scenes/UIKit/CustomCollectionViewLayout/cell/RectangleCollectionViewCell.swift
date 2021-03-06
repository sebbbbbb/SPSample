//
//  RectangleCollectionViewCell.swift
//  SPSample
//
//  Created by Sébastien Pécoul on 04/10/2020.
//  Copyright © 2020 Sébastien Pécoul. All rights reserved.
//

import Reusable
import UIKit

class RectangleCollectionViewCell: UICollectionViewCell, NibReusable {
  
  static let size = CGSize(width: 316, height: 208)
  
  override func awakeFromNib() {
    super.awakeFromNib()
    backgroundColor = .lightGray
  }
  
}
