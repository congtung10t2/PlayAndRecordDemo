//
//  HistoryController.swift
//  RecordAndPlayDemo
//
//  Created by tùng hoàng on 2/15/20.
//  Copyright © 2020 tung hoang. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class HistoryController: UIViewController {
  @IBOutlet weak var history: UITableView!
  var data : [URL] = []
  private var audioPlayer: AVAudioPlayer?
  override func viewDidLoad() {
    super.viewDidLoad()
    data = FileManager.default.urls(for: .documentDirectory) ?? []
    history.dataSource = self
    history.delegate = self
  }
  override func viewWillAppear(_ animated: Bool) {
    data = FileManager.default.urls(for: .documentDirectory) ?? []
    history.reloadData()
  }
  
}
extension FileManager {
    func urls(for directory: FileManager.SearchPathDirectory, skipsHiddenFiles: Bool = true ) -> [URL]? {
        let documentsURL = urls(for: directory, in: .userDomainMask)[0]
        let fileURLs = try? contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil, options: skipsHiddenFiles ? .skipsHiddenFiles : [] )
        return fileURLs
    }
}
extension HistoryController : UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    data.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItemRecorded", for: indexPath) as? ItemRecorded
              else {
                  return ItemRecorded()
          }
    cell.configure(url: data[indexPath.row])
         
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let url = data[indexPath.row];
    audioPlayer = try! AVAudioPlayer(contentsOf: url)
    
    audioPlayer?.prepareToPlay()
    audioPlayer?.play()
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "HISTORY LIST"
  }
  
  func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    let header = view as! UITableViewHeaderFooterView
    header.textLabel?.textColor = .black
    header.textLabel?.font = UIFont(name: "System", size: 16)
    header.textLabel?.baselineAdjustment = .alignCenters
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60.0
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 40.0
  }
}
