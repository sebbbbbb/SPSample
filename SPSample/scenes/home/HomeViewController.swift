//
//  HomeViewController.swift
//  SPSample
//
//  Created by Sebastien on 22/06/2019.
//  Copyright © 2019 Sébastien Pécoul. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  let viewModel = [
    HomeItemViewModel(name: "ComplexTableView", type: ComplexTableViewViewController.self),
    HomeItemViewModel(name: "Layer", type: LayerViewController.self)
  ]
  
  init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }

}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .default, reuseIdentifier: .none)
    cell.textLabel?.text = viewModel[indexPath.row].name
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.navigationController?.pushViewController(viewModel[indexPath.row].type.init(), animated: true)
  }
}

class HomeItemViewModel {
  
  let name: String
  let type: UIViewController.Type
  
  init(name: String, type: UIViewController.Type) {
    self.name = name
    self.type = type
  }
}
