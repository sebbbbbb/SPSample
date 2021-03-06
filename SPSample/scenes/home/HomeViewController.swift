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
  
  let dataSource = Datasource(
    viewModel:[
      HomeItemViewModel(name: "ComplexTableView", type: ComplexTableViewViewController.self),
      HomeItemViewModel(name: "ComplexTableView2", type: ComplexTableViewController2.self),
      HomeItemViewModel(name: "Layer", type: LayerViewController.self),
      HomeItemViewModel(name: "Transition", type: CustomTransitionViewController.self),
      HomeItemViewModel(name: "SQLite", type: SQLLiteViewController.self),
      HomeItemViewModel(name: "Circular Progress View", type: ProgressViewController.self),
      HomeItemViewModel(name: "Rotation", type: RotationViewController.self),
      HomeItemViewModel(name: "Custom collection view layout", type: CollectionViewLayoutViewController.self),
      // HomeItemViewModel(name: "Custom collection view layout with Pod", type: CustomCollectionViewLayoutViewControllerPod.self),
      HomeItemViewModel(name: "CoverFlow effect", type: CoverflowViewController.self),
      HomeItemViewModel(name: "iPad shortcut", type: ShortcutViewController.self),
      HomeItemViewModel(name: "MultiWSProcessViewController", type: MultiWSProcessViewController.self),
      HomeItemViewModel(name: "Custom View", type: CustomViewViewController.self),
      HomeItemViewModel(name: "Audio", type: AudioMenuViewController.self),
      HomeItemViewModel(name: "Animation", type: AnimationViewController.self),
      HomeItemViewModel(name: "Scroll infinie", type: InfiniteScrollViewController.self)
    ]
  )

  init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = dataSource
    tableView.dataSource = dataSource
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
