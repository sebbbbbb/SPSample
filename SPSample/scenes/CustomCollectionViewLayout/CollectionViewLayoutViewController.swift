//
//  CollectionViewLayoutViewController.swift
//  SPSample
//
//  Created by Sébastien Pécoul on 04/10/2020.
//  Copyright © 2020 Sébastien Pécoul. All rights reserved.
//

import UIKit

enum GridItem {
  case cell(Cell)
  case placeHolder
  
  func toString() -> String {
    switch self {
    case .cell(let cell) where cell == .bigSquare:
      return "🥶"
    case .cell(let cell) where cell == .square:
      return "😃"
    case .cell(let cell) where cell == .rectangle:
      return "☺️"
    default:
      return "❌"
    }
  }
}

enum Cell {
  case square
  case rectangle
  case bigSquare
  
  func size() -> CGSize {
    switch self {
    case .square:
      return SquareCollectionViewCellX.size
    case .bigSquare:
      return BigSquareCollectionViewCell.size
    case .rectangle:
      return RectangleCollectionViewCell.size
    }
  }
  
  
  
}

struct Grid {
  
  let columnNb: Int
  let items: [GridItem]
  
  func print() {
    
    var columnCpt = 0
    var str = ""
    for item in items {
      str.append(item.toString())
      str.append(" ")
      columnCpt += 1
      
      if columnCpt == columnNb  {
        debugPrint(str)
        str = ""
        columnCpt = 0
      }
    }
  }
  
  func cellItems() -> [Cell] {
    
    var cells = [Cell]()
    items.forEach { item in
      switch item {
      case .cell(let cell):
        cells.append(cell)
      default:
        break
      }
    }
    
    return cells
  }
}

class CollectionViewLayoutViewController: UIViewController {

  let grid = Grid(
    columnNb: 5,
    items: [
      GridItem.cell(.bigSquare), GridItem.placeHolder, GridItem.cell(.square), GridItem.cell(.square), GridItem.cell(.square),
      GridItem.placeHolder, GridItem.placeHolder, GridItem.cell(.square), GridItem.cell(.square), GridItem.cell(.square),
      GridItem.cell(.square), GridItem.cell(.square), GridItem.cell(.square), GridItem.cell(.square), GridItem.cell(.square),
      GridItem.cell(.rectangle), GridItem.placeHolder, GridItem.placeHolder, GridItem.cell(.square), GridItem.cell(.square),
      GridItem.placeHolder, GridItem.placeHolder, GridItem.placeHolder, GridItem.cell(.square), GridItem.cell(.square)
    ]
  )
  
  
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
    
    grid.print()
  }
  
}

extension CollectionViewLayoutViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return grid.cellItems().count
  }
  
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cellType = grid.cellItems()[indexPath.row]
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

extension CollectionViewLayoutViewController: CustomCollectionLayoutDelegate {
  
  func associatedGrid() -> Grid {
    return grid
  }
}
