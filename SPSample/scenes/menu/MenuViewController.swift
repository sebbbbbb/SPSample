//
//  HomeViewController.swift
//  SPSample
//
//  Created by Sebastien on 22/06/2019.
//  Copyright © 2019 Sébastien Pécoul. All rights reserved.
//

import UIKit


class MenuViewController: UIViewController {
  
  
  enum MenuType {
    case home
    case UIKit
    case audio
    case animations
    case other
    case persistence
    
    init(string: String) {
      switch string {
      case "UIKit":
        self = .UIKit
      case "Audio":
        self = .audio
      case "Animation":
        self = .animations
      case "Other":
        self = .other
      case "Persistence":
        self = .persistence
      default:
        fatalError()
      }
    }
    
    func dataSource() -> Datasource {
      switch self {
      case .home:
        return Datasource(
          viewModel:[
            HomeItemViewModel(name: "UIKit", type: MenuViewController.self),
            HomeItemViewModel(name: "Audio", type: MenuViewController.self),
            HomeItemViewModel(name: "Animation", type: MenuViewController.self),
            HomeItemViewModel(name: "Persistence", type: MenuViewController.self),
            HomeItemViewModel(name: "Other", type: MenuViewController.self),
          ]
        )
      case .UIKit:
        return Datasource(
          viewModel: [
            HomeItemViewModel(name: "ComplexTableView", type: ComplexTableViewViewController.self),
            HomeItemViewModel(name: "ComplexTableView2", type: ComplexTableViewViewController.self),
            HomeItemViewModel(name: "Rotation", type: RotationViewController.self),
            HomeItemViewModel(name: "Custom collection view layout", type: CollectionViewLayoutViewController.self),
            HomeItemViewModel(name: "CoverFlow effect", type: CoverflowViewController.self),
            HomeItemViewModel(name: "Custom View", type: CustomViewViewController.self),
            HomeItemViewModel(name: "Scroll infinie", type: InfiniteScrollViewController.self)
          ])
      case .audio:
        return Datasource(
          viewModel: [
            HomeItemViewModel(name: "AVAudioEngine", type: AVAudioEngineViewController.self)
          ])
      case .animations:
        return Datasource(
          viewModel: [
            HomeItemViewModel(name: "Transition", type: CustomTransitionViewController.self),
            HomeItemViewModel(name: "Layer", type: LayerViewController.self),
          ])
      case .persistence:
        return Datasource(
          viewModel: [
            HomeItemViewModel(name: "SQLite", type: SQLLiteViewController.self),
          ])
      case .other:
        return Datasource(
          viewModel: [
            HomeItemViewModel(name: "MultiWSProcessViewController", type: MultiWSProcessViewController.self),
            HomeItemViewModel(name: "iPad shortcut", type: ShortcutViewController.self)
          ])
      }
    }
  }
  
  
  @IBOutlet weak var tableView: UITableView!
  private let dataSource: Datasource
  
  init(type: MenuType) {
    self.dataSource = type.dataSource()
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
