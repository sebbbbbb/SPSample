//
//  SquareCollectionViewCell.swift
//  SPSample
//
//  Created by Sébastien Pécoul on 04/10/2020.
//  Copyright © 2020 Sébastien Pécoul. All rights reserved.
//

import Reusable
import UIKit


class SquareCollectionViewCellX: UICollectionViewCell, NibReusable {
  
  static let size = CGSize(width: 100, height: 100)
  
  override func awakeFromNib() {
    super.awakeFromNib()
    backgroundColor = .red
  }

}
