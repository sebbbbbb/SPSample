//
//  AsyncOperation.swift
//  SPSample
//
//  Created by Sébastien Pécoul on 12/11/2020.
//  Copyright © 2020 Sébastien Pécoul. All rights reserved.
//

import Foundation

class AsyncOperation: Operation {
  private var isDoing = false {
    willSet {
      if #available(iOS 11, *) {
        willChangeValue(for: \AsyncOperation.isExecuting)
        return
      }
      willChangeValue(forKey: "isExecuting")
    }

    didSet {
      if #available(iOS 11, *) {
        didChangeValue(for: \AsyncOperation.isExecuting)
        return
      }
      didChangeValue(forKey: "isExecuting")
    }
  }
  private var isDone = false {
    willSet {
      if #available(iOS 11, *) {
        willChangeValue(for: \AsyncOperation.isFinished)
        return
      }
      willChangeValue(forKey: "isFinished")
    }

    didSet {
      if #available(iOS 11, *) {
        didChangeValue(for: \AsyncOperation.isFinished)
        return
      }
      didChangeValue(forKey: "isFinished")
    }
  }

  override var isAsynchronous: Bool {
    return true
  }

  override var isExecuting: Bool {
    return isDoing
  }

  override var isFinished: Bool {
    return isDone
  }

  func finish() {
    isDoing = false
    isDone = true
  }

  override func start() {
    if isCancelled {
      finish()
      return
    }

    isDoing = true
    main()
  }

  override func main() {
    fatalError("Override this function in a subclass")
  }
}
