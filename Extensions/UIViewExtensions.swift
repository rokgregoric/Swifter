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

  class func nib(name: String? = nil, bundle: Bundle? = nil) -> UINib {
    return UINib(nibName: name ?? identifier, bundle: bundle)
  }

  class func loadFromNib() -> Self {
    return castToSelf(loadFromNibNamed()!)
  }

  class func loadFromNibNamed(_ name: String? = nil, bundle: Bundle? = nil) -> UIView? {
    return nib(name: name, bundle: bundle).instantiate(withOwner: nil, options: nil).first as? UIView
  }

  var isVisible: Bool {
    return window != nil
  }

  // MARK: - Transform

  @IBInspectable var rotation: CGFloat {
    get { return 0 }
    set { transform = CGAffineTransform(rotationAngle: newValue * 2 * .pi) }
  }

  @IBInspectable var scale: CGFloat {
    get { return 0 }
    set { transform = CGAffineTransform(scaleX: newValue, y: newValue) }
  }

  @IBInspectable var smallPhoneScale: CGFloat {
    get { return 0 }
    set { if isSmallPhone { scale = newValue } }
  }

  @IBInspectable var normalPhoneScale: CGFloat {
    get { return 0 }
    set { if isNormalPhone { scale = newValue } }
  }

  @IBInspectable var largePhoneScale: CGFloat {
    get { return 0 }
    set { if isLargePhone { scale = newValue } }
  }

  @IBInspectable var tallPhoneScale: CGFloat {
    get { return 0 }
    set { if isTallPhone { scale = newValue } }
  }

  @IBInspectable var normalTallPhoneScale: CGFloat {
    get { return 0 }
    set { if isNormalTallPhone { scale = newValue } }
  }

  @IBInspectable var normalShortPhoneScale: CGFloat {
    get { return 0 }
    set { if isNormalShortPhone { scale = newValue } }
  }

  @IBInspectable var largeTallPhoneScale: CGFloat {
    get { return 0 }
    set { if isLargeTallPhone { scale = newValue } }
  }

  @IBInspectable var largeShortPhoneScale: CGFloat {
    get { return 0 }
    set { if isLargeShortPhone { scale = newValue } }
  }

  @IBInspectable var iPadScale: CGFloat {
    get { return 0 }
    set { if isIpad { scale = newValue } }
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
    gradient.cornerRadius = cornerRadius
    gradient.frame = bounds
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

  func snapshotView() -> UIView {
    let iv = UIImageView(image: snapshot())
    iv.frame = frame
    return iv
  }

  func roundCorners(radius: CGFloat? = nil) {
    cornerRadius = radius ?? (height / 2)
    clipsToBounds = true
  }

  func roundTopCorners(radius: CGFloat? = nil) {
    round(corners: [.topLeft, .topRight], radius: radius)
  }

  func round(corners: UIRectCorner, radius: CGFloat? = nil) {
    let maskLayer = CAShapeLayer()
    let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius!, height: radius!)).cgPath
    maskLayer.path = path
    maskLayer.shadowColor = UIColor.black.cgColor
    maskLayer.shadowPath = path
    maskLayer.shadowOffset = CGSize(width: -2, height: -2)
    maskLayer.shadowRadius = radius!
    self.layer.mask = maskLayer
  }

  // MARK: - Shadow & Border layer

  func addShadow(color: UIColor = .black, radius: CGFloat = 3, offset: CGSize = .zero, opacity: Float = 0.2) {
    layer.shadowColor = color.cgColor
    layer.shadowRadius = radius
    layer.shadowOpacity = opacity
    layer.shadowOffset = offset
    layer.masksToBounds = false
  }

  func removeShadow() {
    layer.shadowColor = nil
    layer.shadowRadius = 0
    layer.shadowOpacity = 0
    layer.shadowOffset = .zero
  }

  @IBInspectable var shadowColor: UIColor? {
    get { return UIColor(cgColor: layer.shadowColor!) }
    set { layer.shadowColor = newValue?.cgColor }
  }

  @IBInspectable var borderColor: UIColor? {
    get { return UIColor(cgColor: layer.borderColor!) }
    set { layer.borderColor = newValue?.cgColor }
  }

  @IBInspectable var borderWidth: CGFloat {
    get { return layer.borderWidth }
    set { layer.borderWidth = newValue }
  }

  @IBInspectable var pixelBorderWidth: CGFloat {
    get { return borderWidth * mainScreenScale }
    set { borderWidth = Double(newValue).pixelValue }
  }

  @IBInspectable var cornerRadius: CGFloat {
    get { return layer.cornerRadius }
    set { layer.cornerRadius = newValue }
  }

  @IBInspectable var continuousCornerRadius: Bool {
    get {
      if #available(iOS 13.0, *) { return layer.cornerCurve == .continuous }
      return false
    }
    set {
      if #available(iOS 13.0, *) { layer.cornerCurve = newValue ? .continuous : .circular }
    }
  }

  // MARK: - Standard animation

  class func animate(_ animations: @escaping () -> Void) {
    animate(animations) {}
  }

  class func animate(delay: Double, animations: @escaping () -> Void) {
    animate(delay: delay, animations) {}
  }

  class func animate(_ animations: @escaping () -> Void, completion: @escaping () -> Void) {
    animate(delay: 0, animations, completion: completion)
  }

  class func animate(delay: Double, _ animations: @escaping () -> Void, completion: @escaping () -> Void) {
    animate(duration: animationDuration, delay: delay, options: animationOptionsCurveEaseOut.union(.allowUserInteraction), animations, completion: completion)
  }

  class func animate(duration: Double, delay: Double = 0, options: UIView.AnimationOptions = [], _ animations: @escaping () -> Void) {
    animate(duration: duration, delay: delay, options: options, animations) {}
  }

  class func animate(duration: Double, delay: Double = 0, options: UIView.AnimationOptions = [], _ animations: @escaping () -> Void, completion: @escaping () -> Void) {
    animate(withDuration: duration, delay: delay, options: options.union(.allowUserInteraction), animations: animations) { _ in completion() }
  }

  class func spring(_ duration: Double, delay: Double = 0, damping: CGFloat, velocity: CGFloat, _ animations: @escaping () -> Void) {
    spring(duration, delay: delay, damping: damping, velocity: velocity, animations) {}
  }

  class func spring(_ duration: Double, delay: Double = 0, damping: CGFloat, velocity: CGFloat, _ animations: @escaping () -> Void, completion: @escaping () -> Void) {
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
