//
//  ContainerTableViewCell.swift
//  SPSample
//
//  Created by Sebastien on 07/07/2019.
//  Copyright © 2019 Sébastien Pécoul. All rights reserved.
//

import Reusable
import UIKit

class ContainerTableViewCell: UITableViewCell, NibReusable {
  
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var labelTitle: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    collectionView.register(cellType: MovieCollectionViewCell.self)
    collectionView.register(cellType: SerieCollectionViewCell.self)
  }
  
  func setup(dataSource: UICollectionViewDataSource, delegate: UICollectionViewDelegate) {
    collectionView.delegate = delegate
    collectionView.dataSource = dataSource
  }
  
  static func height() -> CGFloat {
    return 60
  }
  
}
