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
  let operationManager = OperationManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Custom
    test = Warehouse(processes: [FirstProcessX(), SecondProcess(), ThirdProcess()])
 
    
//    // Promise
//    PromiseLiteConfiguration.debugger = DefaultPromiseLiteDebugger { print($0) }
//    promiseFirstTask()
//      .flatMap { self.promiseSecondTask(model:$0) }
//      .flatMap { self.promiseThirdTask(model:$0) }
//      .map { debugPrint($0) }
  }
  
  
  @IBAction func launchProcess() {
//    test.launch() {
//      switch $0 {
//      case .success(let model):
//        debugPrint("☺️")
//        debugPrint(model)
//      case .failure:
//        debugPrint("🤬")
//        debugPrint("Error")
//      }
//    }
    
    operationManager.load(operations: [.mostViewedProgram]) {
      switch $0 {
      case .success(let model):
        debugPrint("☺️")
        debugPrint(model)
      case .failure:
        debugPrint("🤬")
        debugPrint("Error")
      }
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
      
      self.operationManager.update(operations: [.favorite, .lastPlayedEpisodes]) {
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
}

class Model {
  let id: Int
  let name: String
  let count: Int
  let rating: Int
  
  init(id: Int, name: String, count: Int, rating: Int) {
    self.id = id
    self.name = name
    self.count = count
    self.rating = rating
  }
  
  func merge(with model: Model) -> Model {
    return Model(
      id: id,
      name: name + model.name,
      count: count + model.count,
      rating: rating + model.rating
    )
  }
  
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
  
  var isMandatory: Bool = true
  
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


// MARK: Opération implem

extension MultiWSProcessViewController {
  
  class Storage {
    var model: Model?
    
    init() {
      self.model = nil
    }
  }
  
  class OperationManager {
    
    
    enum Operation {
      
      case favorite
      case homeFetching
  
      case mostViewedProgram
      case lastPlayedEpisodes
    }
    
    
    let storage = Storage()
    
    
    
    func load(operations: [Operation], completion: @escaping (Result<Model, SampleError>) -> Void) {
      
      DispatchQueue.global(qos: .userInteractive).async {
        
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 3
    
        let homeOperation = self.operation(.homeFetching)
        
        let otherOperations = operations.map { self.operation($0) }
        otherOperations.forEach { $0.addDependency(homeOperation) }
        queue.addOperations([homeOperation] + otherOperations, waitUntilFinished: true)

        DispatchQueue.main.async { [self] in
          if let model = storage.model {
            completion(.success(model))
          } else {
            completion(.failure(SampleError(code: 0)))
          }
        }
      }
    }
    
    func update(operations: [Operation], completion: @escaping (Result<Model, SampleError>) -> Void) {
      DispatchQueue.global(qos: .userInteractive).async {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 3
        let otherOperations = operations.map { self.operation($0) }
        queue.addOperations(otherOperations, waitUntilFinished: true)
        DispatchQueue.main.async { [self] in
          if let model = storage.model {
            completion(.success(model))
          } else {
            completion(.failure(SampleError(code: 0)))
          }
        }
      }
    }
    
    // MARK:
    
    func operation(_ operation: Operation) -> AsyncOperation {
      switch operation {
      case .favorite:
        return favoriteOperation()
      case .homeFetching:
        return FirstOperation() { operation, result in
          switch result {
          case .failure:
            operation?.cancel()
            operation?.finish()
          case .success(let model):
            self.storage.model = model
          }
          debugPrint("End 1")
          operation?.finish()
        }
      case .lastPlayedEpisodes:
        return resumeOperation()
      case .mostViewedProgram:
        return topOperation()
      }
    }
    
    func favoriteOperation() -> AsyncOperation {
      return SecondOperation(storage: storage) { operation, result in
        
        switch result {
        case .failure:
          break
        case .success(let model):
          self.storage.model = self.storage.model!.merge(with: model)
        }
        
        operation?.finish()
      }
    }
    
    func topOperation() -> AsyncOperation {
      return FourthOperation(storage: storage) { operation, result in
        
        switch result {
        case .failure:
          break
        case .success(let model):
          self.storage.model = self.storage.model!.merge(with: model)
        }
        
        operation?.finish()
      }
    }
    
    func resumeOperation() -> AsyncOperation {
      return ThirdOperation(storage: storage) { operation, result in
       
        
        switch result {
        case .failure:
          break
        case .success(let model):
          self.storage.model = self.storage.model!.merge(with: model)
        }
        
        operation?.finish()
      }
    }
    
    /*
    func launch(completion: @escaping (Result<Model, SampleError>) -> Void) {
      
      DispatchQueue.global(qos: .userInteractive).async {
        
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 3
        
        let operation2 = SecondOperation(input: self.model) { operation, result in
          debugPrint("End 2")
          
          switch result {
          case .failure:
            break
          case .success(let model):
            self.model = self.model!.merge(with: model)
          }
          
          operation?.finish()
        }
        
        let operation3 = ThirdOperation(input: ) { operation, result in
          debugPrint("End 3")
          
          switch result {
          case .failure:
            break
          case .success(let model):
            self.model = self.model!.merge(with: model)
          }
          
          operation?.finish()
        }
        
        let operation1 = FirstOperation() { operation, result in
          switch result {
          case .failure:
            operation?.cancel()
            operation?.finish()
          case .success(let model):
            self.model = model
          }
          
          debugPrint("End 1")
          operation?.finish()
        }
        
        operation2.addDependency(operation1)
        operation3.addDependency(operation1)
        queue.addOperations([operation1, operation2, operation3], waitUntilFinished: true)

        DispatchQueue.main.async { [self] in
          
          if let model = storage.model {
            completion(.success(model))
          } else {
            
            completion(.failure(SampleError(code: 0)))
         
          }
        }
      }
    }*/
  }
  
  class FirstOperation: AsyncOperation {
  
    let completion: (AsyncOperation?, Result<Model, SampleError>) -> Void
    
    init(completion: @escaping (AsyncOperation?, Result<Model, SampleError>) -> Void) {
      self.completion = completion
    }
    
    override func main() {
      guard !isCancelled,
        dependencies.filter({ $0.isCancelled }).isEmpty else {
          cancel()
          finish()
          return
      }
      
      firstTask { result in
        self.completion(self, result)
      }
      
    }
  }
  
  class SecondOperation: AsyncOperation {
  
    let completion: (AsyncOperation?, Result<Model, SampleError>) -> Void
    let storage: Storage
    
    init(storage: Storage, completion: @escaping (AsyncOperation?, Result<Model, SampleError>) -> Void) {
      self.storage = storage
      self.completion = completion
    }
    
    override func main() {
      guard !isCancelled,
        dependencies.filter({ $0.isCancelled }).isEmpty else {
          cancel()
          finish()
          return
      }
      
      secondTask(model: storage.model!) { result in
        self.completion(self, result)
      }
      
    }
  }
  
  class ThirdOperation: AsyncOperation {
  
    let completion: (AsyncOperation?, Result<Model, SampleError>) -> Void
    let storage: Storage
    
    init(storage: Storage, completion: @escaping (AsyncOperation?, Result<Model, SampleError>) -> Void) {
      self.storage = storage
      self.completion = completion
    }
    
    override func main() {
      guard !isCancelled,
        dependencies.filter({ $0.isCancelled }).isEmpty else {
          cancel()
          finish()
          return
      }
      
      thirdTask(model: storage.model!) { result in
        self.completion(self, result)
      }
      
    }
  }
  
  class FourthOperation: AsyncOperation {
  
    let completion: (AsyncOperation?, Result<Model, SampleError>) -> Void
    let storage: Storage
    
    init(storage: Storage, completion: @escaping (AsyncOperation?, Result<Model, SampleError>) -> Void) {
      self.storage = storage
      self.completion = completion
    }
    
    override func main() {
      guard !isCancelled,
        dependencies.filter({ $0.isCancelled }).isEmpty else {
          cancel()
          finish()
          return
      }
      
      fourthTask(model: storage.model!) { result in
        self.completion(self, result)
      }
      
    }
  }
  
}

// MARK:


func firstTask(completion: @escaping ((Result<Model, SampleError>) -> Void)) {
  DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
    completion(.success(Model(id: 0, name: "A name", count: 1, rating: 0)))
    //completion(.failure(SampleError(code: 0)))
    
  }
}

func secondTask(model: Model, completion: @escaping ((Result<Model, SampleError>) -> Void)) {
  DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
    //completion(.failure(SampleError(code: 0)))
    debugPrint("Favorite finished")
    completion(.success(Model(id: 0, name: "Simon", count: 100, rating: 100)))
  }
}

func thirdTask(model: Model, completion: @escaping ((Result<Model, SampleError>) -> Void)) {
  DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
    //completion(.failure(SampleError(code: 0)))
    debugPrint("Resume finished")
    completion(.success(Model(id: 0, name: "Peppa", count: 4, rating: -2)))
  }
}

func fourthTask(model: Model, completion: @escaping ((Result<Model, SampleError>) -> Void)) {
  DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
    debugPrint("Top media finished")
    //completion(.failure(SampleError(code: 0)))
    completion(.success(Model(id: 0, name: "Peppa", count: 1000, rating: -2)))
  }
}
