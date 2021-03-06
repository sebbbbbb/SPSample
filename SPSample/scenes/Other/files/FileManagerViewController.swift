//
//  FileManagerViewController.swift
//  SPSample
//
//  Created by Sébastien Pécoul on 12/12/2018.
//  Copyright © 2018 Sébastien Pécoul. All rights reserved.
//

import UIKit

// Resources:
// - https://www.youtube.com/watch?v=eC7_cddT6wM
class FileManagerViewController: UIViewController {
    
    
    
    @IBAction func createFiles() {
        
        let tempDirectoryPath = NSTemporaryDirectory()
        let tempDirectory = URL(fileURLWithPath: tempDirectoryPath)
        
        let fileContent = """
        Do you see any Teletubbies in here? Do you see a slender plastic tag clipped to my shirt with my name printed on it? Do you see a little Asian child with a blank expression on his face sitting outside on a mechanical helicopter that shakes when you put quarters in it? No? Well, that's what you see at a toy store. And you must think you're in a toy store, because you're here shopping for an infant named Jeb.
        """
        
        let saveURL = tempDirectory.appendingPathComponent("files.txt")
        try! fileContent.write(to: saveURL, atomically: true, encoding: .utf8)
    
    }
    
    @IBAction func listFiles() {
        debugPrint("List files :")
        let fileManager = FileManager.default
        let directoryList = try! fileManager.contentsOfDirectory(at: URL(fileURLWithPath: NSTemporaryDirectory()), includingPropertiesForKeys: nil, options: [.skipsHiddenFiles, .skipsPackageDescendants, .skipsSubdirectoryDescendants])
        directoryList.forEach {
            debugPrint($0)
        }
        
    }
    
    @IBAction func deleteFiles() {
        
        
        
    }
    
    
}
