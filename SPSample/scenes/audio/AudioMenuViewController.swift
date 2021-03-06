//
//  AudioMenuViewController.swift
//  SPSample
//
//  Created by Sébastien Pécoul on 20/02/2021.
//  Copyright © 2021 Sébastien Pécoul. All rights reserved.
//

import UIKit

class AudioMenuViewController: UIViewController {
  
  @IBOutlet private weak var tableView: UITableView!
  private let dataSource = Datasource(viewModel: [
    HomeItemViewModel(name: "AVAudioEngine", type: AVAudioEngineViewController.self)
  ])
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = dataSource
    tableView.dataSource = dataSource
  }
}
