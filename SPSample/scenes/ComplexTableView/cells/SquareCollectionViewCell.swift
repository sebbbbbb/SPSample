//
//  SquareCollectionViewCell.swift
//  SPSample
//
//  Created by Sebastien on 22/06/2019.
//  Copyright © 2019 Sébastien Pécoul. All rights reserved.
//

import Reusable
import UIKit

class SquareCollectionViewCell: UICollectionViewCell, NibReusable {
  
  @IBOutlet weak var bgView: UIView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    let colors = [UIColor.red, UIColor.blue, UIColor.yellow, UIColor.green, UIColor.gray, UIColor.cyan]
    bgView.backgroundColor = colors[Int.random(in: 0..<colors.count)]
   
    contentView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      contentView.leftAnchor.constraint(equalTo: leftAnchor),
      contentView.rightAnchor.constraint(equalTo: rightAnchor),
      contentView.topAnchor.constraint(equalTo: topAnchor),
      contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
    
  }
  
}
