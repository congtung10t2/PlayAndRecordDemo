//
//  UIView+Extensions.swift
//  RecordAndPlayDemo
//
//  Created by tùng hoàng on 2/15/20.
//  Copyright © 2020 tung hoang. All rights reserved.
//

import UIKit

@IBDesignable
extension UIView {
  
  @IBInspectable var cornerRadius: CGFloat {
    get {
      return layer.cornerRadius
    }
    set {
      layer.cornerRadius = newValue
    }
  }
  
  @IBInspectable var shadowColor: UIColor? {
    get {
      guard let color = layer.shadowColor
        else {
          return nil
      }
      return UIColor(cgColor: color)
    }
    set {
      layer.shadowColor = newValue?.cgColor
    }
  }
  
  @IBInspectable var shadowSize: CGSize {
    get {
      return self.layer.shadowOffset
    }
    set {
      self.layer.shadowOffset = newValue
    }
  }
  
  @IBInspectable var shadowOpacity: CGFloat {
    get {
      return CGFloat(self.layer.shadowOpacity)
    }
    set {
      self.layer.shadowOpacity = Float(newValue)
    }
  }
  
  @IBInspectable var shadowRadius: CGFloat {
    get {
      return self.layer.shadowRadius
    }
    set {
      self.layer.shadowRadius = newValue
    }
  }
  
  @IBInspectable var borderColor: UIColor? {
    get {
      guard let color = layer.borderColor
        else {
          return nil
      }
      return UIColor(cgColor: color)
    }
    set {
      layer.borderColor = newValue?.cgColor
    }
  }
  
  @IBInspectable var borderWidth: CGFloat {
    get {
      return layer.borderWidth
    }
    set {
      layer.borderWidth = newValue
    }
  }
  
  func addBottomBorder(color: UIColor, width: CGFloat) {
    let border = CALayer()
    border.backgroundColor = color.cgColor
    border.opacity = 0.5
    border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
    self.layer.addSublayer(border)
  }
}

extension CALayer {
  
  enum action {
    case hide
    case show
  }
  
  func commonTransition(action: action, delegate: CAAnimationDelegate?){
    let transition = CATransition()
    transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
    transition.type = CATransitionType.push
    switch action {
    case .hide:
      transition.subtype = .fromTop
    case .show:
      transition.subtype = .fromBottom
    }
    transition.delegate = delegate;
    self.add(transition, forKey: CATransitionType.push.rawValue);
  }
  
}
