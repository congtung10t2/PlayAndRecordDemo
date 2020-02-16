//
//  ViewController.swift
//  RecordAndPlayDemo
//
//  Created by tùng hoàng on 2/15/20.
//  Copyright © 2020 tung hoang. All rights reserved.
//

import UIKit
import AVFoundation
import CoreMIDI

enum State {
  case play
  case stop
  case record
  case none
}

class ViewController: UIViewController {
  
  @IBOutlet weak var record: UIButton!
  @IBOutlet weak var play: UIButton!
  @IBOutlet weak var name: UITextField!
  @IBOutlet weak var recordingLabel: UILabel!
  
  private var audioPlayer:AVAudioPlayer?
  private var avAudioPlayer: AVAudioPlayer?
  private var audioRecorder: AVAudioRecorder!
  private var audioRecordingSession: AVAudioSession!
  private let url = NSURL(fileURLWithPath: Bundle.main.path(forResource: "TryKy", ofType: "mp3")!)
  private var state : State = .none
  override func viewDidLoad() {
    super.viewDidLoad()
    audioPlayer = try! AVAudioPlayer(contentsOf: url.absoluteURL!)
    audioPlayer?.delegate = self
    audioPlayer?.prepareToPlay()
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
    
    //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
    //tap.cancelsTouchesInView = false

    view.addGestureRecognizer(tap)
    AVAudioSession.sharedInstance().requestRecordPermission { granted in
        if granted {
            // The user granted access. Present recording interface.
        } else {
          self.showAlertAction(title: "Warning", message: "There is no microphone permission for Application. Please allow it to use your microphone")
        }
    }

    
    // Do any additional setup after loading the view.
  }
  @objc func dismissKeyboard() {
      //Causes the view (or one of its embedded text fields) to resign the first responder status.
      view.endEditing(true)
  }
  @IBAction func recordWithMusic() {
    if(name.text?.count ?? 0 > 0) {
      audioPlayer?.play()
      setupRecorder()
      audioRecorder.record()
      self.controlAudio(.record)
    } else {
      showAlert(title: "Warning", message: "The record name is blank, fill something first!")
    }
  }
  
  @IBAction func stop() {
    if state == .play {
      audioRecorder.stop()
      audioPlayer?.stop()
      name.resignFirstResponder()
      self.controlAudio(.stop)
    } else {
      showAlert(title: "Warning", message: "You should record something first!")
    }
    
    //DispatchQueue.main.asyncAfter(deadline: 1, execute: {
      
  }
  @IBAction func playRecorded() {
    if let audio = avAudioPlayer {
      avAudioPlayer?.play()
      self.controlAudio(.play)
    } else {
      showAlert(title: "Warning", message: "You should record then save it first!")
    }
    
      
  }
  
  func setupRecorder() {
    var error: NSError?
    let session = AVAudioSession.sharedInstance()
    try! session.setCategory(AVAudioSession.Category.playAndRecord)
    try! session.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsDirectory = paths[0]
    let audioFilename = documentsDirectory.appendingPathComponent(name.text!)
    let settings = [AVFormatIDKey: Int(kAudioFormatAppleLossless),
                    AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue,
                    AVEncoderBitRateKey : 320000,
                    AVNumberOfChannelsKey: 2,
                    AVSampleRateKey: 44100.0] as [String : Any]
    
    do {
      audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
    } catch {
      audioRecorder = nil
    }
    if let error = error {
      print("loi qua")
    } else {
      audioRecorder.delegate = self
      audioRecorder.prepareToRecord()
    }
  }
  func getFileURL() -> URL {
    let fileManager = FileManager.default
    let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsDirectory = urls[0]
    let soundURL = documentsDirectory.appendingPathComponent(name.text!)
    return soundURL
  }
  
  func controlAudio(_ state: State) {
    var str = ""
    self.state = state
    switch state {
    case .play:
      str = "Playing back"
    case .stop:
      str = "Record file is saved"
      
    case .record:
      str = "Recording"
    case .none:
      break;
    }
    self.recordingLabel.text = str
  }
  
}
extension ViewController : AVAudioPlayerDelegate {
  
}
extension ViewController : AVAudioRecorderDelegate {
  func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool){
    if(flag) {
      avAudioPlayer = try! AVAudioPlayer(contentsOf: getFileURL())
      avAudioPlayer?.delegate = self
      avAudioPlayer?.prepareToPlay()
    }
  }
}
