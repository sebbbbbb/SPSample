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
    test.launch() {
      switch $0 {
      case .success(let model):
        debugPrint("☺️")
        debugPrint(model)
      case .failure:
        debugPrint("🤬")
        debugPrint("Error")
      }
    }
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

protocol Process {
  var isMandatory: Bool { get set }
  func execute(model: Model, completion: @escaping ((Result<Model, SampleError>) -> Void))
}

class Warehouse {
  
  let processes: [Process]
  init(processes: [Process]){
    self.processes = processes
  }
  
  func launch(completion: @escaping ((Result<Model, SampleError>) -> Void)) {
    execute(model: Model(id: 0, name: "", count: 0, rating: 0), processes: processes) {
      completion($0)
    }
  }
  
  func execute(model: Model, processes: [Process], completion: @escaping ((Result<Model, SampleError>) -> Void)) {
 
    if processes.isEmpty {
      completion(.success(model))
      return
    }
    
    var xyz = processes
    
    processes[0].execute(model: model) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let model2):
        xyz.removeFirst()
        self.execute(model: model2, processes: xyz, completion: completion)
      case .failure where processes[0].isMandatory:
        debugPrint("End - Failure")
        completion(.failure(SampleError(code: 0)))
        break // ??
      case .failure:
        xyz.removeFirst()
        self.execute(model: model, processes: xyz, completion: completion)
      }
    }
  }
}

class FirstProcess: Process {
    
  var isMandatory: Bool = false
  
//  func execute(model: Model, completion: @escaping ((Result<Model, SampleError>) -> Void)) {
//    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
//      debugPrint("End 1")
//      completion(.failure(SampleError(code: 0)))
//    }
//  }
  
  func execute(model: Model, completion: @escaping ((Result<Model, SampleError>) -> Void)) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
      completion(.success(Model(id: 0, name: "", count: model.count + 10, rating: 0)))
    }
  }
  
  
}

class SecondProcess: Process {

  var isMandatory: Bool = false
  
//  func execute(model: Model, completion: @escaping ((Result<Model, SampleError>) -> Void)) {
//    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
//      debugPrint("End 2")
//      completion(.failure(SampleError(code: 0)))
//    }
//  }
  
  func execute(model: Model, completion: @escaping ((Result<Model, SampleError>) -> Void)) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
      completion(.success(Model(id: 0, name: "Pépé", count: model.count - 5, rating: 0)))
    }
  }

}

class ThirdProcess: Process {

  var isMandatory: Bool = false

  func execute(model: Model, completion: @escaping ((Result<Model, SampleError>) -> Void)) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
      completion(.failure(SampleError(code: 0)))
    }
  }
}




class SampleError: Error {
  
  let code: Int
  
  init(code: Int) {
    self.code = code
  }
  
  
}
