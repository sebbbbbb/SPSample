//
//  ComplexTableViewController2.swift
//  SPSample
//
//  Created by Sebastien on 07/07/2019.
//  Copyright © 2019 Sébastien Pécoul. All rights reserved.
//

import UIKit

class ComplexTableViewController2: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  let dataSources: [UICollectionViewDataSource & UICollectionViewDelegateFlowLayout & DataSource] = [
    MovieDatasource(),
    SerieDataSource(),
    MovieDatasource(),
    SerieDataSource()
  ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(cellType: ContainerTableViewCell.self)
  }
}

extension ComplexTableViewController2: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(for: indexPath) as ContainerTableViewCell
    cell.setup(dataSource: dataSources[indexPath.row], delegate: dataSources[indexPath.row])
    return cell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataSources.count
  }

}

extension ComplexTableViewController2: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let dataSource = dataSources[indexPath.row]
    return dataSource.cellHeight() + ContainerTableViewCell.height()
  }
  
}
