//
//  SerieDataSource.swift
//  SPSample
//
//  Created by Sebastien on 07/07/2019.
//  Copyright © 2019 Sébastien Pécoul. All rights reserved.
//

import UIKit

class SerieDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, DataSource {

  let items = 10
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return items
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    return collectionView.dequeueReusableCell(for: indexPath) as SerieCollectionViewCell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: cellHeight(), height: cellHeight())
  }
  
  func cellHeight() -> CGFloat {
    return 200.0
  }
}
