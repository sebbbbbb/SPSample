//
//  MultiWSProcessViewController.swift
//  SPSample
//
//  Created by Sébastien Pécoul on 10/11/2020.
//  Copyright © 2020 Sébastien Pécoul. All rights reserved.
//

import PromiseLite
import UIKit

class MultiWSProcessViewController: UIViewController {
  
  var test: Warehouse!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Custom
    test = Warehouse(processes: [FirstProcessX(), SecondProcess(), ThirdProcess()])
    
    // Promise
    
    PromiseLiteConfiguration.debugger = DefaultPromiseLiteDebugger { print($0) }
    promiseFirstTask()
      .flatMap { self.promiseSecondTask(model:$0) }
      .flatMap { self.promiseThirdTask(model:$0) }
      .map { debugPrint($0) }
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
}

protocol FirstProcess: Process {
  func execute(completion: @escaping ((Result<Model, SampleError>) -> Void))
}

protocol NextProcess: Process {
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
    
    let myClosure: ((Result<Model, SampleError>) -> Void) = { [weak self] result in
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
    
    
    if let process = processes[0] as? FirstProcess {
      process.execute(completion: myClosure)
    } else if let process = processes[0] as? NextProcess {
      process.execute(model: model, completion: myClosure)
    } else {
      assertionFailure()
    }
  }
}

class FirstProcessX: FirstProcess {
  
  var isMandatory: Bool = false
  
  func execute(completion: @escaping ((Result<Model, SampleError>) -> Void)) {
    firstTask(completion: completion)
  }
  
  
}

class SecondProcess: NextProcess {
  
  var isMandatory: Bool = false
  
  func execute(model: Model, completion: @escaping ((Result<Model, SampleError>) -> Void)) {
    secondTask(model: model, completion: completion)
  }
  
}

class ThirdProcess: NextProcess {
  
  var isMandatory: Bool = false
  
  func execute(model: Model, completion: @escaping ((Result<Model, SampleError>) -> Void)) {
    thirdTask(model: model, completion: completion)
  }
}




class SampleError: Error {
  
  let code: Int
  
  init(code: Int) {
    self.code = code
  }
  
  
}


// MARK: Pod Implem

extension MultiWSProcessViewController {
  
}


// MARK: Opération implem

extension MultiWSProcessViewController {
  
  func promiseFirstTask() -> PromiseLite<Model> {
    PromiseLite<Model> { resolve, reject in
      firstTask { result in
        switch result {
        case .success(let model):
          resolve(model)
        case .failure(let error):
          reject(error)
        }
      }
    }
  }
  
  // Optionnal
  func promiseSecondTask(model: Model) -> PromiseLite<Model> {
    PromiseLite<Model> { resolve, reject in
      secondTask(model: model) { result in
        switch result {
        case .success(let innerModel):
          resolve(innerModel)
        case .failure(let error):
          resolve(model)
        }
      }
    }
  }
  
  
  // Optionnal
  func promiseThirdTask(model: Model) -> PromiseLite<Model> {
    PromiseLite<Model> { resolve, reject in
      thirdTask(model: model) { result in
        switch result {
        case .success(let innerModel):
          resolve(innerModel)
        case .failure(let error):
          resolve(model)
        }
      }
    }
  }
  
}


// MARK:


func firstTask(completion: @escaping ((Result<Model, SampleError>) -> Void)) {
  DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
    completion(.success(Model(id: 0, name: "A name", count: 1, rating: 0)))
  }
}

func secondTask(model: Model, completion: @escaping ((Result<Model, SampleError>) -> Void)) {
  DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
    completion(.failure(SampleError(code: 0)))
    //completion(.success(Model(id: 0, name: "A name", count: model.count * 3, rating: 0)))
  }
}

func thirdTask(model: Model, completion: @escaping ((Result<Model, SampleError>) -> Void)) {
  DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
    completion(.failure(SampleError(code: 0)))
    //completion(.success(Model(id: 0, name: "A name", count: model.count * 5, rating: 0)))
  }
}
