//
//  CircleCollectionViewCell.swift
//  SPSample
//
//  Created by Sebastien on 22/06/2019.
//  Copyright © 2019 Sébastien Pécoul. All rights reserved.
//

import Reusable
import UIKit

class CircleCollectionViewCell: UICollectionViewCell, NibReusable {
  
  override func awakeFromNib() {
    super.awakeFromNib()
    contentView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      contentView.leftAnchor.constraint(equalTo: leftAnchor),
      contentView.rightAnchor.constraint(equalTo: rightAnchor),
      contentView.topAnchor.constraint(equalTo: topAnchor),
      contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
      ])
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    contentView.layer.cornerRadius = contentView.layer.frame.height * 0.5
    contentView.clipsToBounds = true
  }
  
}
