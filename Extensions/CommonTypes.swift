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
let deviceName = UIDevice.current.name

extension XApplication {
  var isActive: Bool { applicationState == .active }
  var isSleeping: Bool { applicationState == .background }
  static let backgroundTaskInvalid = UIBackgroundTaskIdentifier.invalid
}

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
let deviceName = Host.current().localizedName ?? ""
var sleepNotificationTriggered = false

extension XApplication {
  var isSleeping: Bool { sleepNotificationTriggered } // listen to NSWorkspace.willSleepNotification / .didWakeNotification
  func endBackgroundTask(_ id: Int) {}
  static let backgroundTaskInvalid = 0
  func beginBackgroundTask(_: @escaping () -> Void) -> Int { 0 }
}

let hardwareInfo: [String: String]? = {
  guard let data = "system_profiler SPHardwareDataType -json".runData() else { return nil }
  do {
    let decoder = JSONDecoder()
    let hardwareInfo = try decoder.decode([String: [[String: String]]].self, from: data)
    return hardwareInfo["SPHardwareDataType"]?.first
  } catch {
    print("Error: \(error)")
    return nil
  }
}()

let deviceIdentifier = hardwareInfo?["machine_model"]

#endif

let deviceArchitecture: String = {
  var systemInfo = utsname()
  uname(&systemInfo)
  let mirror = Mirror(reflecting: systemInfo.machine)

  let identifier = mirror.children.reduce("") { identifier, element in
    guard let value = element.value as? Int8, value != 0 else { return identifier }
    return identifier + String(UnicodeScalar(UInt8(value)))
  }
  return identifier
}()

let deviceModel: String = {
  var size: size_t = 0
  sysctlbyname("hw.model", nil, &size, nil, 0)
  var machine = [CChar](repeating: 0, count: Int(size))
  sysctlbyname("hw.model", &machine, &size, nil, 0)
  return String(cString: machine)
}()

let urlSafeDeviceName = deviceName.regmove("[^a-zA-Z0-9]*").lowercased()
