//
//  UIViewControllerExtensions.swift
//
//  Created by Rok Gregorič
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

import UIKit

extension UIViewController {
  class func instantiate(_ name: UIStoryboard.Name, identifier: String? = nil) -> Self {
    return instantiate(string: name.rawValue, identifier: identifier ?? self.identifier)
  }

  class func instantiate(string: String, identifier: String? = nil) -> Self {
    return castToSelf(UIStoryboard.instantiate(string: string, identifier: identifier ?? self.identifier))
  }

  func segue(to controller: UIViewController.Type, with sender: Any? = nil) {
    performSegue(withIdentifier: controller.identifier, sender: sender)
  }

  static var mainWindow: UIWindow? {
    return UIApplication.shared.delegate?.window ?? nil
  }

  static var rootVC: UIViewController? {
    var rootVC = mainWindow?.rootViewController
    if let nc = rootVC as? UINavigationController { rootVC = nc.visibleViewController }
    if let tbc = rootVC as? UITabBarController { rootVC = tbc.selectedViewController }
    while let pvc = rootVC?.presentedViewController { rootVC = pvc }
    return rootVC
  }

  static func switchRoot(to vc: UIViewController, animated: Bool = true) {
    let window = mainWindow
    // always dismiss all child controllers otherwise they are retained by the view hierarchy
    window?.rootViewController?.dismiss(animated: false)

    window?.rootViewController = vc
    if animated { window?.fade(UIView.animationDuration) }
  }

  var isFocussed: Bool {
    return view.isVisible && presentedViewController == nil
  }
}

// MARK: - Controller Management

extension UIViewController {
  func add(child: UIViewController) {
    child.beginAppearanceTransition(true, animated: false)
    addChild(child)
    child.didMove(toParent: self)
    view.addSubview(child.view)
    child.endAppearanceTransition()
  }

  func remove(child: UIViewController?) {
    guard let child = child else { return }
    child.beginAppearanceTransition(false, animated: false)
    child.willMove(toParent: nil)
    child.removeFromParent()

    if child.viewIfLoaded?.superview != nil {
      child.viewIfLoaded?.removeFromSuperview()
    }

    child.endAppearanceTransition()
  }
}

// MARK: - Navigation Controller Helpers

extension UIViewController {
  var navBar: UINavigationBar? {
    return navigationController?.navigationBar
  }

  // workaround to enable interactivePopGestureRecognizer
  open override func awakeFromNib() {
    super.awakeFromNib()
    navigationController?.setInteractivePopGestureRecognizer(enabled: true)
  }

  fileprivate var nc: UINavigationController? {
    return (self as? UINavigationController) ?? navigationController
  }

  func push(_ vc: UIViewController, animated: Bool) {
    nc?.pushViewController(vc, animated: animated)
  }

  func pop(animated: Bool) {
    nc?.popViewController(animated: animated)
  }

  func pop(to vc: UIViewController, animated: Bool) {
    nc?.popToViewController(vc, animated: animated)
  }

  func popToRoot(animated: Bool) {
    nc?.popToRootViewController(animated: animated)
  }
}

// MARK: - UIPopoverPresentationController

extension UIPopoverPresentationController {
  enum Position {
    case min(CGFloat)
    case mid(CGFloat)
    case max(CGFloat)
  }

  func setup(x: Position, y: Position, color: UIColor? = nil, vc: UIViewController? = nil) {
    if let sourceView = sourceView {
      let rectX: CGFloat
      let rectY: CGFloat
      switch x {
        case .min(let offset): rectX = sourceView.bounds.minX + offset
        case .mid(let offset): rectX = sourceView.bounds.midX + offset
        case .max(let offset): rectX = sourceView.bounds.maxX + offset
      }
      switch y {
        case .min(let offset): rectY = sourceView.bounds.minY + offset
        case .mid(let offset): rectY = sourceView.bounds.midY + offset
        case .max(let offset): rectY = sourceView.bounds.maxY + offset
      }
      sourceRect = CGRect(x: rectX, y: rectY, width: 0, height: 0)
    }
    backgroundColor = color ?? vc?.view.backgroundColor
  }

  func setup(view: UIView?, arrowDirections: UIPopoverArrowDirection) {
    sourceView = view
    permittedArrowDirections = arrowDirections
  }
}

