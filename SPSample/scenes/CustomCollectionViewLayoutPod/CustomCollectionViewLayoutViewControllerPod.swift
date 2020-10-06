//
//  CustomCollectionViewLayoutViewControllerPod.swift
//  SPSample
//
//  Created by Sébastien Pécoul on 06/10/2020.
//  Copyright © 2020 Sébastien Pécoul. All rights reserved.
//

import collection_view_layouts
import Reusable
import UIKit

class CustomCollectionViewLayoutViewControllerPod: UIViewController {

  let hArray = [100, 200, 300, 100, 100, 100, 200, 300, 100, 100, 100, 200, 300, 100, 100].shuffled()
  
  @IBOutlet private weak var collectionView: UICollectionView!
  
  init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    collectionView.register(cellType: SquareCollectionViewCellX.self)
    collectionView.register(cellType: RectangleCollectionViewCell.self)
    collectionView.register(cellType: BigSquareCollectionViewCell.self)
    
    let layout = Px500Layout()
    layout.delegate = self
    layout.cellsPadding = ItemsPadding(horizontal: 8, vertical: 8)

    collectionView.collectionViewLayout = layout
    collectionView.reloadData()
    
 
  }
  
}

extension CustomCollectionViewLayoutViewControllerPod: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return hArray.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    return collectionView.dequeueReusableCell(for: indexPath) as SquareCollectionViewCellX
  }
}

extension CustomCollectionViewLayoutViewControllerPod: LayoutDelegate {
  func cellSize(indexPath: IndexPath) -> CGSize {
    return CGSize(width: 100, height: hArray[indexPath.row])
  }
}
