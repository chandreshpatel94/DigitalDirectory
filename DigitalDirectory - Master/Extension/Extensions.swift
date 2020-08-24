//
//  Extensions.swift
//  DigitalDirectory - Master
//
//  Created by CHANDRESH on 22/08/20.
//  Copyright © 2020 CHANDRESH. All rights reserved.
//

import UIKit
import Foundation
import SVProgressHUD

//MARK: - UITextField
extension UITextField {
  func setIcon(_ image: UIImage) {
    let iconView = UIImageView(frame: CGRect(x: 10, y: 5, width: 20, height: 20))
    iconView.image = image
    let iconContainerView: UIView = UIView(frame: CGRect(x: 20, y: 0, width: 50, height: 30))
    iconContainerView.addSubview(iconView)
    rightView = iconContainerView
    rightViewMode = .always
  }
  
  func setLeftPadding(_ amount: CGFloat) {
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: frame.size.height))
    leftView = paddingView
    leftViewMode = .always
  }
  
  func setRightPadding(_ amount: CGFloat) {
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: frame.size.height))
    rightView = paddingView
    rightViewMode = .always
  }
}

//MARK: - UIView
extension UIView {
  static var reuseIdentifier: String {
    return String(describing: self)
  }
  
  func cornerRadius(radius: CGFloat = 15.0) {
    layer.cornerRadius = radius
    layer.masksToBounds = true
    layoutIfNeeded()
  }
  
  func roundView() {
    layer.cornerRadius = frame.height / 2
    layer.masksToBounds = true
    layoutIfNeeded()
  }
  
  func addShadow(offset: CGSize, color: UIColor = .black, radius: CGFloat, opacity: Float, bgColor: UIColor? = nil) {
    layer.masksToBounds = false
    layer.shadowOffset = offset
    layer.shadowColor = color.cgColor
    layer.shadowRadius = radius
    layer.shadowOpacity = opacity
    
    let backgroundCGColor = backgroundColor?.cgColor
    backgroundColor = nil
    layer.backgroundColor =  bgColor == nil ? backgroundCGColor : bgColor?.cgColor
  }
}

//MARK: - UIViewController
extension UIViewController {
  static var storyboardIdentifier: String {
    return String(describing: self)
  }
  
  func showAlert(message: String, title: String = "") {
    SVProgressHUD.dismiss()
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(OKAction)
    self.present(alertController, animated: true, completion: nil)
  }
}

//MARK: - String
extension String {
  func storyboard() -> UIStoryboard {
    return UIStoryboard(name: self, bundle: nil)
  }
  var floatValue: Float {
    return (self as NSString).floatValue
  }
}

//MARK: - UIColor
extension UIColor {
  convenience init(red: Int, green: Int, blue: Int) {
    assert(red >= 0 && red <= 255, "Invalid red component")
    assert(green >= 0 && green <= 255, "Invalid green component")
    assert(blue >= 0 && blue <= 255, "Invalid blue component")
    
    self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
  }
  
  convenience init(rgb: Int) {
    self.init(
      red: (rgb >> 16) & 0xFF,
      green: (rgb >> 8) & 0xFF,
      blue: rgb & 0xFF
    )
  }
  
  convenience init(hexString: String) {
    let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    var int = UInt64()
    Scanner(string: hex).scanHexInt64(&int)
    let a, r, g, b: UInt64
    switch hex.count {
    case 3: // RGB (12-bit)
      (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
    case 6: // RGB (24-bit)
      (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
    case 8: // ARGB (32-bit)
      (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
    default:
      (a, r, g, b) = (255, 0, 0, 0)
    }
    self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
  }
}


class AppFunction {
  
  static var shared = AppFunction()
  
  func viewControllerWith(_ identifier: String, storyboard: String = "Main") -> UIViewController? {
    return storyboard.storyboard().instantiateViewController(withIdentifier: identifier)
  }
}

class CustomTextField: UITextField {
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
    layer.cornerRadius = 10
    layer.masksToBounds = true
    layer.borderWidth = 2
    layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
    setLeftPadding(20)
    setRightPadding(20)
    attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.5)])
  }
}

class CustomView: UIView {
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
    cornerRadius(radius: 10.0)
    addShadow(offset: CGSize(width: 0, height: 2), radius: 4, opacity: 0.4)
  }
}
