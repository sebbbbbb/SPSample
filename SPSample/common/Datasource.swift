//
//  Datasource.swift
//  SPSample
//
//  Created by Sébastien Pécoul on 20/02/2021.
//  Copyright © 2021 Sébastien Pécoul. All rights reserved.
//

import UIKit

class Datasource: NSObject, UITableViewDataSource, UITableViewDelegate {
  
  let viewModel: [HomeItemViewModel]
  
  init(viewModel: [HomeItemViewModel]) {
    self.viewModel = viewModel
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .default, reuseIdentifier: .none)
    cell.textLabel?.text = viewModel[indexPath.row].name
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let targetVCType = viewModel[indexPath.row].type
    if targetVCType == MenuViewController.self {
      let menuType = MenuViewController.MenuType(string: viewModel[indexPath.row].name)
      UIApplication.topNavigationController().pushViewController(MenuViewController(type: menuType), animated: true)
    } else {
      UIApplication.topNavigationController().pushViewController(viewModel[indexPath.row].type.init(), animated: true)
    }
  }
}
