//
//  UIViewExtensions.swift
//
//  Created by Rok Gregorič
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

import UIKit

extension UIView {

  static let fadeDuration = 0.2
  static let animationDuration = 0.4
  static let animationOptionsCurveEaseOut = UIView.AnimationOptions(rawValue: 7 << 16)

  static var identifier: String {
    return String(describing: self)
  }

  class func loadFromNib() -> Self {
    return castToSelf(loadFromNibNamed(identifier)!)
  }

  class func loadFromNibNamed(_ name: String, bundle: Bundle? = nil) -> UIView? {
    return UINib(nibName: name, bundle: bundle).instantiate(withOwner: nil, options: nil).first as? UIView
  }

  var isVisible: Bool {
    return window != nil
  }

  // MARK: - Transform

  @IBInspectable var rotation: CGFloat {
    get { return 0 }
    set { transform = transform.rotated(by: newValue * 2 * .pi) }
  }

  @IBInspectable var scale: CGFloat {
    get { return 0 }
    set { transform = CGAffineTransform(scaleX: newValue, y: newValue) }
  }

  @IBInspectable var iPhoneXscale: CGFloat {
    get { return 0 }
    set { if isIphoneX { transform = CGAffineTransform(scaleX: newValue, y: newValue) } }
  }

  @IBInspectable var iPhoneSEscale: CGFloat {
    get { return 0 }
    set { if isIphoneSE { transform = CGAffineTransform(scaleX: newValue, y: newValue) } }
  }

  // MARK: - Frame helpers

  @nonobjc
  var width: CGFloat {
    get { return frame.width }
    set { frame.size.width = newValue }
  }

  @nonobjc
  var height: CGFloat {
    get { return frame.height }
    set { frame.size.height = newValue }
  }

  func set(x: CGFloat, y: CGFloat) {
    frame.origin = CGPoint(x: x, y: y)
  }

  func set(x: CGFloat) {
    frame.origin.x = x
  }

  func set(y: CGFloat) {
    frame.origin.y = y
  }

  func set(width: CGFloat, height: CGFloat) {
    frame.size = CGSize(width: width, height: height)
  }

  func set(width: CGFloat) {
    frame.size.width = width
  }

  func set(height: CGFloat) {
    frame.size.height = height
  }

  // MARK: - Fade

  func fade(_ duration: Double = fadeDuration) {
    let fade = CATransition()
    fade.duration = duration
    fade.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    layer.add(fade, forKey: CATransitionType.fade.rawValue)
  }

  // MARK: - Graphics

  func addGradient(from fromColor: UIColor, to toColor: UIColor) {
    let gradient = CAGradientLayer()
    gradient.cornerRadius = self.layer.cornerRadius
    gradient.frame = self.bounds
    gradient.colors = [fromColor.cgColor, toColor.cgColor]
    self.layer.insertSublayer(gradient, at: 0)
  }

  func snapshot() -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
    layer.render(in: UIGraphicsGetCurrentContext()!)
    let img = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return img
  }

  func roundCorners(radius: CGFloat? = nil) {
    self.layer.cornerRadius = radius ?? (self.frame.size.height / 2)
    self.clipsToBounds = true
  }

  func roundTopCorners(radius: CGFloat? = nil) {
    let maskLayer = CAShapeLayer()
    let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: radius!, height: radius!)).cgPath
    maskLayer.path = path
    maskLayer.shadowColor = UIColor.black.cgColor
    maskLayer.shadowPath = path
    maskLayer.shadowOffset = CGSize(width: -2, height: -2)
    maskLayer.shadowRadius = radius!
    self.layer.mask = maskLayer
  }

  // MARK: - Shadow & Border layer

  func addShadow(radius: CGFloat? = nil, offset: CGSize = .zero, opacity: Float = 0.2) {
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowRadius = radius ?? layer.cornerRadius
    layer.shadowOpacity = opacity
    layer.shadowOffset = offset
    layer.masksToBounds = false
  }

  @IBInspectable var shadowColor: UIColor? {
    get { return UIColor(cgColor: layer.shadowColor!) }
    set { layer.shadowColor = newValue?.cgColor }
  }

  @IBInspectable var borderColor: UIColor? {
    get { return UIColor(cgColor: layer.borderColor!) }
    set { layer.borderColor = newValue?.cgColor }
  }

  @IBInspectable var pixelBorderWidth: CGFloat {
    get { return layer.borderWidth * mainScreenScale }
    set { layer.borderWidth = Double(newValue).pixelValue }
  }

  // MARK: - Standard animation

  class func animate(_ animations: @escaping () -> Void) {
    animate(animations) {}
  }

  class func animate(_ delay: Double, animations: @escaping () -> Void) {
    animate(delay, animations: animations) {}
  }

  class func animate(_ animations: @escaping () -> Void, completion: @escaping () -> Void) {
    animate(0, animations: animations, completion: completion)
  }

  class func animate(_ delay: Double, animations: @escaping () -> Void, completion: @escaping () -> Void) {
    animate(withDuration: animationDuration, delay: delay, options: animationOptionsCurveEaseOut.union(.allowUserInteraction), animations: animations) { _ in completion() }
  }

  class func spring(_ duration: Double, delay: Double = 0, damping: CGFloat, velocity: CGFloat, animations: @escaping () -> Void) {
    spring(duration, delay: delay, damping: damping, velocity: velocity, animations: animations) {}
  }

  class func spring(_ duration: Double, delay: Double = 0, damping: CGFloat, velocity: CGFloat, animations: @escaping () -> Void, completion: @escaping () -> Void) {
    animate(withDuration: duration, delay: delay, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: .allowUserInteraction, animations: animations) { _ in completion() }
  }
}

protocol NibRegistrable {
  func registerNib(_ nib: UINib, reuseIdentifier: String)
}

extension NibRegistrable {
  func registerNib(_ type: AnyClass) {
    let name = String(describing: type.self)
    registerNibNamed(name)
  }

  func registerNibNamed(_ name: String) {
    let nib = UINib(nibName: name, bundle: nil)
    registerNib(nib, reuseIdentifier: name)
  }
}

extension UITableView: NibRegistrable {
  func registerNib(_ nib: UINib, reuseIdentifier: String) {
    register(nib, forCellReuseIdentifier: reuseIdentifier)
  }
}

extension UICollectionView: NibRegistrable {
  func registerNib(_ nib: UINib, reuseIdentifier: String) {
    register(nib, forCellWithReuseIdentifier: reuseIdentifier)
  }

  var flowLayout: UICollectionViewFlowLayout? {
    return collectionViewLayout as? UICollectionViewFlowLayout
  }
}
