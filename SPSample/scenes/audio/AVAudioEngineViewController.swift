//
//  AVAudioEngineViewController.swift
//  SPSample
//
//  Created by Sébastien Pécoul on 20/02/2021.
//  Copyright © 2021 Sébastien Pécoul. All rights reserved.
//

import AVFoundation
import UIKit

/// Useful links :
// https://www.slideshare.net/bobmccune/building-modern-audio-apps-with-avaudioengine
// https://www.robotlovesyou.com/mixing-between-effects-with-avfoundation/
class AVAudioEngineViewController: UIViewController {
  
  // engine
  let audioEngine = AVAudioEngine()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  //  try! AVAudioSession.sharedInstance().setActive(true, options: [])
    
    let audioFile = try! AVAudioFile(forReading: Bundle.main.url(forResource: "download_no_downloaded_content", withExtension: ".mp3")!)
    let buffer = AVAudioPCMBuffer(pcmFormat: audioFile.processingFormat, frameCapacity: AVAudioFrameCount(audioFile.length))!
   // try! audioFile.read(into: buffer)
    
   
    
    
    // nodes
    // 3 types of nodes
    // - source -> player|mic
    // - processing -> mixer|effect
    // - destination -> ouput

    let reverb = AVAudioUnitReverb()
    reverb.wetDryMix = 25
    reverb.loadFactoryPreset(.cathedral)
    
    let distortion = AVAudioUnitDistortion()
    distortion.wetDryMix = 25
    distortion.loadFactoryPreset(.speechRadioTower)
    
    let audioPlayerNode1 = AVAudioPlayerNode()
  
    // attach nodes
    audioEngine.attach(audioPlayerNode1)
    audioEngine.attach(reverb)
    audioEngine.attach(distortion)
  
    
    audioPlayerNode1.scheduleFile(audioFile, at: nil, completionHandler: nil)
    
   
    // Sound effect connections
    audioEngine.connect(audioPlayerNode1, to: distortion, fromBus: 0, toBus: 0, format: nil)
    audioEngine.connect(distortion, to: reverb, fromBus: 0, toBus: 0, format: nil)
    
    // Here we're making multiple output connections from the player node 1) to the main mixer and 2) to another mixer node we're using for adding effects.
    
//    let playerConnectionPoints = [
//      AVAudioConnectionPoint(node: audioEngine.mainMixerNode, bus: 0),
//      AVAudioConnectionPoint(node: audioMixer, bus: 1)
//    ]
    
    audioEngine.connect(reverb, to: audioEngine.mainMixerNode, format: nil)
  
   
 
    
    
    
   // audioPlayerNode1.scheduleBuffer(buffer, at: nil, options: .loops, completionHandler: nil)
    
    
    
    // Prepare and start audioEngine
    audioEngine.prepare()
    do {
      try audioEngine.start()
      audioPlayerNode1.play()
    }
    catch {
      // HANDLE ERROR
    }
    
    
  }
  
  
}
