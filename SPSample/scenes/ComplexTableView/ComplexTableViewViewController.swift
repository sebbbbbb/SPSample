//
//  ComplexTableViewViewController.swift
//  SPSample
//
//  Created by Sebastien on 22/06/2019.
//  Copyright © 2019 Sébastien Pécoul. All rights reserved.
//

import Reusable
import UIKit

class ComplexTableViewViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  
  let dataSources = [CircleDataSource(), CircleDataSource(), HorizontalDataSource()]
  
  init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(cellType: ContainerCell.self)
    
    title = "TableView"
  }
}


extension ComplexTableViewViewController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataSources.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(for: indexPath) as ContainerCell
    cell.setUp(dataSource: dataSources[indexPath.row] as! UICollectionViewDataSource & UICollectionViewDelegate)
    cell.layoutIfNeeded()
    cell.cHeight.constant = cell.collectionView.collectionViewLayout.collectionViewContentSize.height + 30
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
}


// MARK: Cell

final class ContainerCell: UITableViewCell, NibReusable {
  
  @IBOutlet weak var cHeight: NSLayoutConstraint!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var collectionLayout: UICollectionViewFlowLayout! {
    didSet {
      //collectionLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    collectionView.register(cellType: SquareCollectionViewCell.self)
    collectionView.register(cellType: CircleCollectionViewCell.self)
  }
  
  
  
  func setUp(dataSource: UICollectionViewDataSource & UICollectionViewDelegate) {
    collectionView.dataSource = dataSource
    collectionView.reloadData()
  //  collectionView.layoutIfNeeded()
  }
}
