//
//  SQLLiteViewController.swift
//  SPSample
//
//  Created by Sébastien Pécoul on 06/04/2020.
//  Copyright © 2020 Sébastien Pécoul. All rights reserved.
//

import SQLite
import UIKit



extension Connection {
    public var userVersion: Int32 {
        get { return Int32(try! scalar("PRAGMA user_version") as! Int64)}
        set { try! run("PRAGMA user_version = \(newValue)") }
    }
}

protocol LikeDataManager {
  
}

class SQLLiteViewController: UIViewController {
  
  var db: Connection!
  
  let user = Table("user")
  let userId = Expression<Int64>("id")
  let userage = Expression<Int64>("age")
  
  let userPrograms = Table("user_programs")
  let userProgramsId = Expression<Int64>("id")
  let userProgramsIdProgram = Expression<Int64>("idProgram")
  let userProgramsIdUser = Expression<Int64>("idUser")
  let userProgramsLiked = Expression<Bool>("liked")
  
  let sessionVideo = Table("session_video")
  let sessionVideoId = Expression<Int64>("id")
  let sessionVideoIdVideoId = Expression<Int64>("id_video")
  let sessionVideoIdUserProgram = Expression<Int64>("id_user_program")
  let sessionVideoDuration = Expression<Int64>("duration")
  let sessionVideoPlayTime = Expression<Int64>("play_time")
  let sessionVideoResumeTime = Expression<Int64>("resume_time")
  let sessionVideoDate = Expression<Date>("video_date")
  
  init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "SQLIte"
    
    
    createAndConnectToDB()
    createTables()
    //  db.trace { print($0) }
    
    debugPrint(db.userVersion)
    
  }
  
  // MARK: - Actions
  
  @IBAction func generateSampleData() {
    // User
    try! db.run(user.insert(userId <- 0, userage <- 3))
    try! db.run(user.insert(userId <- 1, userage <- 3))
    
    // User program
    for i in 0...200 {
      try! db.run(userPrograms.insert(
        userProgramsId <- Int64(i),
        userProgramsLiked <- false,
        userProgramsIdUser <- Int64(1),
        userProgramsIdProgram <- Int64(i))
      )
    }
    
    // Session Video
    for i in 0...100_000 {
      try! db.run(sessionVideo.insert(
        sessionVideoId <- Int64(i),
        sessionVideoIdUserProgram <- Int64(Int.random(in: 0...100)),
        sessionVideoIdVideoId <- Int64(Int.random(in: 0...100)),
        sessionVideoDuration <- Int64(Int.random(in: 0...3600)),
        sessionVideoPlayTime <- Int64(Int.random(in: 0...3600)),
        sessionVideoDate <- Date().addingTimeInterval(TimeInterval(Int.random(in: 0...36_000))),
        sessionVideoResumeTime <- Int64(Int.random(in: 0...3600)))
      )
    }
    
  }
  
  @IBAction func dumpData() {
    
    // Find if program X is Like or not
    let query = userPrograms
      .select(userProgramsId)
      .filter(userProgramsId == 19)
    
    for program in try! db.prepare(query) {
      debugPrint("ID : \(program[userProgramsId])")
    }
    
    
    // Find SessionVideo of associated ID
    let query2 = sessionVideo
      .filter(sessionVideo[sessionVideoIdUserProgram] == 10)
      .join(userPrograms, on: sessionVideoIdUserProgram == userPrograms[userProgramsIdProgram])
    
    for sessionVideoX in try! db.prepare(query2) {
      debugPrint("Query 2 --  ID2 : \(sessionVideoX[sessionVideo[sessionVideoIdUserProgram]]) ID1 : \(sessionVideoX[sessionVideo[sessionVideoId]])")
    }
    
    // Find SessionVideo and filter
    let query3 = sessionVideo
      .filter(sessionVideoIdUserProgram == 10)
    
    for sessionVideo in try! db.prepare(query3) {
      debugPrint("Query 3 -- ID Program : \(sessionVideo[sessionVideoIdUserProgram]) ID Video : \(sessionVideo[sessionVideoIdVideoId]) Date : \(sessionVideo[sessionVideoDate]) ")
    }
    
    // Find last session for given video ID
    let query4 = sessionVideo.select([sessionVideoIdVideoId, sessionVideoId, sessionVideoDate])
      .filter(sessionVideoIdVideoId == 10)
      .filter(sessionVideoResumeTime < sessionVideoDuration)
      .order(sessionVideoDate.desc)
      .limit(1)
    
    for sessionVideo in try! db.prepare(query4) {
      debugPrint("Query 4 -- ID Session : \(sessionVideo[sessionVideoId]) ID Video : \(sessionVideo[sessionVideoIdVideoId]) Date : \(sessionVideo[sessionVideoDate]) ")
    }
    
    // Find session for given videos ID
    let query5 = sessionVideo.select(sessionVideoIdVideoId, sessionVideoId, sessionVideoDate.max)
      .filter([1, 10, 11, 111, 42].contains(sessionVideoIdVideoId))
      .filter(sessionVideoResumeTime < sessionVideoDuration)
      .group(sessionVideoIdVideoId)
    
    for sessionVideo in try! db.prepare(query5) {
      debugPrint("Query 5 -- ID Session : \(sessionVideo[sessionVideoId]) ID Video : \(sessionVideo[sessionVideoIdVideoId])")
    }
    
  }
  
  @IBAction func request1() {
    queryLikedProgram(programID: 10)
  }
  
  
  @IBAction func request2() {
    queryAssociatedProgramSession(programID: 23)
  }
  
  
  @IBAction func request3() {
    queryAssociatedProgramSessionWithFilter(programID: 23)
  }
  
  
  @IBAction func request4() {
    querySessionVideoID(ids: [1, 10, 20, 4, 2])
  }
  
  @IBAction func nukeData() {
    
  }
  
  @IBAction func performRequest() {
    
  }
  
  // MARK: - Private methods
  
  func queryLikedProgram(programID: Int64) {
    printTimeElapsedWhenRunningCode(title: #function) {
      let query = userPrograms
        .select(userProgramsId)
        .filter(userProgramsId == programID)
      
      for program in try! db.prepare(query) {}
    }
  }
  
  func queryAssociatedProgramSession(programID: Int64) {
    
    printTimeElapsedWhenRunningCode(title: #function) {
      let query = sessionVideo
        .filter(userPrograms[userProgramsIdProgram] == programID)
        //  .filter(sessionVideo[sessionVideoIdUserProgram] == programID)
        .join(userPrograms, on: sessionVideoIdUserProgram == userPrograms[userProgramsIdProgram])
      
      
      for sessionVideoX in try! db.prepare(query) {
        debugPrint("Query --  ID2 : \(sessionVideoX[sessionVideo[sessionVideoIdUserProgram]]) ID1 : \(sessionVideoX[sessionVideo[sessionVideoId]])")
      }
    }
  }
  
  func queryAssociatedProgramSessionWithFilter(programID: Int64) {
    printTimeElapsedWhenRunningCode(title: #function) {
      let query = sessionVideo.filter(sessionVideoIdUserProgram == programID)
      for sessionVideo in try! db.prepare(query) {
        debugPrint("Query  -- ID Program : \(sessionVideo[sessionVideoIdUserProgram]) ID Video : \(sessionVideo[sessionVideoIdVideoId]) Date : \(sessionVideo[sessionVideoDate]) ")
      }
    }
  }
  
  func querySessionVideoID(ids: [Int64]) {
    
    printTimeElapsedWhenRunningCode(title: #function) {
      let query = sessionVideo.select(sessionVideoIdVideoId, sessionVideoId, sessionVideoDate.max)
        .filter(ids.contains(sessionVideoIdVideoId))
        .filter(sessionVideoResumeTime < sessionVideoDuration)
        .group(sessionVideoIdVideoId)
      
      for sessionVideo in try! db.prepare(query) {}
    }
  }
  
  private func createAndConnectToDB() {
    let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    debugPrint(path)
    db = try! Connection("\(path)/db.sqlite3")
  }
  
  private func createTables() {
    
    try! db.run(user.create(ifNotExists: true) { t in
      t.column(userId, primaryKey: true)
      t.column(userage)
    })
    
    try! db.run(userPrograms.create(ifNotExists: true) { t in
      t.column(userProgramsId, primaryKey: true)
      t.column(userProgramsLiked)
      t.column(userProgramsIdUser)
      t.column(userProgramsIdProgram)
      t.foreignKey(userId, references: user, userId, delete: .setNull)
    })
    
    try! db.run(sessionVideo.create(ifNotExists: true) { t in
      t.column(sessionVideoId, primaryKey: true)
      t.column(sessionVideoIdVideoId)
      t.column(sessionVideoIdUserProgram)
      t.column(sessionVideoDuration)
      t.column(sessionVideoPlayTime)
      t.column(sessionVideoResumeTime)
      t.column(sessionVideoDate)
      t.foreignKey(sessionVideoIdUserProgram, references: userPrograms, userProgramsIdProgram, delete: .setNull)
    })
    
  }
  
}


func printTimeElapsedWhenRunningCode(title:String, operation:()->()) {
  let startTime = CFAbsoluteTimeGetCurrent()
  operation()
  let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
  print("Time elapsed for \(title): \(timeElapsed) s.")
}
