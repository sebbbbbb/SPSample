//
//  CollectionViewLayoutViewController.swift
//  SPSample
//
//  Created by Sébastien Pécoul on 04/10/2020.
//  Copyright © 2020 Sébastien Pécoul. All rights reserved.
//

import UIKit

class CollectionViewLayoutViewController: UIViewController {
  
  enum Cell {
    case square
    case rectangle
    case bigSquare
  }
  
  let cells: [Cell] = [
    .bigSquare,
    .square, .square, .square, .square, .square, .square, .square, .square, .square, .square, .square, .square, .square, .square, .square, .square, .square, .square, .square, .square, .square, .square
    ].shuffled()
  
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
    
    if let layout = collectionView?.collectionViewLayout as? CustomCollectionLayout {
      layout.delegate = self
    }
  }
  
}

extension CollectionViewLayoutViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return cells.count
  }
  
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cellType = cells[indexPath.row]
    switch cellType {
    case .rectangle:
      return collectionView.dequeueReusableCell(for: indexPath) as RectangleCollectionViewCell
    case .square:
      return collectionView.dequeueReusableCell(for: indexPath) as SquareCollectionViewCellX
    case .bigSquare:
      return collectionView.dequeueReusableCell(for: indexPath) as BigSquareCollectionViewCell
    }
  }
}

extension CollectionViewLayoutViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let cellType = cells[indexPath.row]
    switch cellType {
    case .rectangle:
      return RectangleCollectionViewCell.size
    case .square:
      return SquareCollectionViewCellX.size
    case .bigSquare:
      return BigSquareCollectionViewCell.size
    }
  }
}

extension CollectionViewLayoutViewController: CustomCollectionLayoutDelegate {
  func collectionView(_ collectionView: UICollectionView, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
    let cellType = cells[indexPath.row]
    switch cellType {
    case .rectangle:
      return RectangleCollectionViewCell.size
    case .square:
      return SquareCollectionViewCellX.size
    case .bigSquare:
      return BigSquareCollectionViewCell.size
    }
  }
}
