//
//  MultiWSProcessViewController.swift
//  SPSample
//
//  Created by Sébastien Pécoul on 10/11/2020.
//  Copyright © 2020 Sébastien Pécoul. All rights reserved.
//

import UIKit

class MultiWSProcessViewController: UIViewController {
  
  var test: Warehouse!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    test = Warehouse(processes: [FirstProcess(), SecondProcess(), ThirdProcess()])
  }
  
  
  @IBAction func launchProcess() {
    test.launch()
  }
  
  
}

struct Model {
  let id: Int
  let name: String
  let count: Int
  let rating: Int
}

extension Model: CustomDebugStringConvertible {
  var debugDescription: String {
    "\(id) - \(name) - \(count) - \(rating)"
  }
}

typealias ProcessStep = (Model) -> (Result<Model, Error>)

protocol Process {
  var isMandatory: Bool { get set }
  var step: ProcessStep { get set }
}

class Warehouse {
  
  let processes: [Process]
  init(processes: [Process]){
    self.processes = processes
  }
  
  func launch() {
    execute(model: Model(id: 0, name: "", count: 0, rating: 0), processes: processes)
  }
  
  func execute(model: Model, processes: [Process]) {
 
    if processes.isEmpty {
      debugPrint(model)
      debugPrint("End")
      return
    }
    
    var xyz = processes
    
    switch processes[0].step(model) {
    case .success(let model2):
      xyz.removeFirst()
      execute(model: model2, processes: xyz)
    case .failure where processes[0].isMandatory:
      debugPrint("End - Failure")
      break // ??
    case .failure:
      xyz.removeFirst()
      execute(model: model, processes: xyz)
    }
  }
}

class FirstProcess: Process {
  
  var isMandatory: Bool = true
  
  var step: ProcessStep = { _ in
    .success(Model(id: 0, name: "Pépé", count: 1, rating: 0))
  }
}

class SecondProcess: Process {
  
  var isMandatory: Bool = false
  
  var step: ProcessStep = { model in
    .failure(SampleError(code: 0))
    //.success(Model(id: 0, name: "Pépé", count: model.count + 10, rating: 0))
  }

}

class ThirdProcess: Process {
  
  var isMandatory: Bool = true
  
  var step: ProcessStep = { model in
    .success(Model(id: 0, name: "Pépé", count: model.count * 10, rating: 0))
  }
}




class SampleError: Error {
  
  let code: Int
  
  init(code: Int) {
    self.code = code
  }
  
  
}
