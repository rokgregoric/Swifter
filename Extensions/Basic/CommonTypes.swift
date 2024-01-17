//
//  CommonTypes.swift
//
//  Created by Rok Gregorič
//  Copyright © 2022 Rok Gregorič. All rights reserved.
//

#if os(iOS)

  import UIKit

  typealias XColor = UIColor
  typealias XImage = UIImage
  typealias XEdgeInsets = UIEdgeInsets
  typealias XApplication = UIApplication
  typealias XLayoutConstraint = NSLayoutConstraint
  typealias XLayoutPriority = UILayoutPriority
  typealias XButton = UIButton
  typealias XCollectionView = UICollectionView

  var uniqueDeviceID: String? { UIDevice.current.identifierForVendor?.uuidString }
  var systemVersion: String { "\(UIDevice.current.systemName) \(UIDevice.current.systemVersion)" }
  var deviceName: String { UIDevice.current.name }

#elseif os(OSX)

  import AppKit

  typealias XColor = NSColor
  typealias XImage = NSImage
  typealias XEdgeInsets = NSEdgeInsets
  typealias XApplication = NSApplication
  typealias XLayoutConstraint = NSLayoutConstraint
  typealias XLayoutPriority = NSLayoutConstraint.Priority
  typealias XButton = NSButton
  typealias XCollectionView = NSCollectionView

  var uniqueDeviceID: String? { nil }
  var systemVersion: String { "macOS \(NSAppKitVersion.current.rawValue)" }
  var deviceName: String { Host.current().localizedName ?? "" }

#endif
