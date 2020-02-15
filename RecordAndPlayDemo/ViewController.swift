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

class ViewController: UIViewController {
  @IBOutlet weak var record: UIButton!
  @IBOutlet weak var play: UIButton!
  private var audioPlayer:AVAudioPlayer?
  private var avAudioPlayer: AVAudioPlayer?
  private var audioRecorder: AVAudioRecorder!
  private var audioRecordingSession: AVAudioSession!
  @IBOutlet weak var name: UITextField!
  private
  let url = NSURL(fileURLWithPath: Bundle.main.path(forResource: "TryKy", ofType: "mp3")!)
  override func viewDidLoad() {
    super.viewDidLoad()
    audioPlayer = try! AVAudioPlayer(contentsOf: url.absoluteURL!)
    audioPlayer?.delegate = self
    audioPlayer?.prepareToPlay()
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")

    //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
    //tap.cancelsTouchesInView = false

    view.addGestureRecognizer(tap)
    AVAudioSession.sharedInstance().requestRecordPermission { granted in
        if granted {
            // The user granted access. Present recording interface.
        } else {
          self.showAlertAction(title: "Warning", message: "There is no microphone permission for ViMap. Please allow it to use your microphone")
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
    } else {
      showAlert(title: "Warning", message: "The record name is blank, fill something first!")
    }
  }
  @IBAction func stop() {
    
    audioRecorder.stop()
    audioPlayer?.stop()
    name.resignFirstResponder()
    //DispatchQueue.main.asyncAfter(deadline: 1, execute: {
      
  }
  @IBAction func playRecorded() {
      avAudioPlayer?.play()
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
extension UIViewController {
  func showAlertAction(title: String, message : String) {
    let alertController = UIAlertController (title: title, message: message, preferredStyle: .alert)
    let settingsAction = UIAlertAction(title: "Setting", style: .default) { (_) -> Void in
      guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
        return
      }
      if UIApplication.shared.canOpenURL(settingsUrl) {
        UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
      }
    }
    alertController.addAction(settingsAction)
    let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
    alertController.addAction(cancelAction)
    DispatchQueue.main.async {
      self.present(alertController, animated: true, completion: nil)
    }
  }
  func showAlert(title: String, message : String) {
         let alertController = UIAlertController(title: title, message:
             message, preferredStyle: .alert)
         alertController.addAction(UIAlertAction(title: "OK", style: .default))
         DispatchQueue.main.async(execute: {
             self.present(alertController, animated: true, completion: nil)
             
         })
         
     }
}
