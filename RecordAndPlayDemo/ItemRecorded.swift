//
//  ItemRecorded.swift
//  RecordAndPlayDemo
//
//  Created by tùng hoàng on 2/15/20.
//  Copyright © 2020 tung hoang. All rights reserved.
//

import Foundation
import UIKit
class ItemRecorded : UITableViewCell {
  @IBOutlet weak var itemName: UILabel!
  func configure(url: URL){
    itemName.text = url.absoluteURL.lastPathComponent
  }
}
