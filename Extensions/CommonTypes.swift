//
//  CommonTypes.swift
//
//  Created by Rok Gregorič
//  Copyright © 2022 Rok Gregorič. All rights reserved.
//

#if os(iOS)

import UIKit

typealias Color = UIColor
typealias Image = UIImage
typealias EdgeInsets = UIEdgeInsets
typealias Application = UIApplication
typealias LayoutConstraint = NSLayoutConstraint
typealias LayoutPriority = UILayoutPriority
typealias Button = UIButton
typealias CollectionView = UICollectionView

var uniqueDeviceID: String? { UIDevice.current.identifierForVendor?.uuidString }
var systemVersion: String { "\(UIDevice.current.systemName) \(UIDevice.current.systemVersion)" }
let deviceName = UIDevice.current.name

extension Application {
  var isActive: Bool { applicationState == .active }
  var isSleeping: Bool { applicationState == .background }
  static let backgroundTaskInvalid = UIBackgroundTaskIdentifier.invalid
}

#elseif os(OSX)

import AppKit

typealias Color = NSColor
typealias Image = NSImage
typealias EdgeInsets = NSEdgeInsets
typealias Application = NSApplication
typealias LayoutConstraint = NSLayoutConstraint
typealias LayoutPriority = NSLayoutConstraint.Priority
typealias Button = NSButton
typealias CollectionView = NSCollectionView

var uniqueDeviceID: String? { nil }
var systemVersion: String { "macOS \(NSAppKitVersion.current.rawValue)" }
let deviceName = Host.current().localizedName ?? ""
var sleepNotificationTriggered = false

extension Application {
  var isSleeping: Bool { sleepNotificationTriggered } // listen to NSWorkspace.willSleepNotification / .didWakeNotification
  func endBackgroundTask(_ id: Int) {}
  static let backgroundTaskInvalid = 0
  func beginBackgroundTask(_: @escaping () -> Void) -> Int { 0 }
}

#endif

let deviceIdentifier: String = {
  var systemInfo = utsname()
  uname(&systemInfo)
  let mirror = Mirror(reflecting: systemInfo.machine)

  let identifier = mirror.children.reduce("") { identifier, element in
    guard let value = element.value as? Int8, value != 0 else { return identifier }
    return identifier + String(UnicodeScalar(UInt8(value)))
  }
  return identifier
}()

let urlSafeDeviceName = deviceName.removed(.alphanumerics.inverted).lowercased()
