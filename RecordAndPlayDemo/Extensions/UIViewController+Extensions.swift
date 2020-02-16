//
//  UIViewController+Extensions.swift
//  RecordAndPlayDemo
//
//  Created by tùng hoàng on 2/16/20.
//  Copyright © 2020 tung hoang. All rights reserved.
//

import Foundation
import UIKit
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
