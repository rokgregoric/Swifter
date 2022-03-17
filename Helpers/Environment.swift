//
//  Environment.swift
//
//  Created by Rok Gregorič
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

import Foundation

struct Environment {
  static func value<T>(for key: String) -> T? {
    return Bundle.main.infoDictionary?[key] as? T
  }

  static var appName: String {
    return value(for: "CFBundleDisplayName") ?? value(for: "CFBundleName") ?? ""
  }

  static var build: String {
    return value(for: "CFBundleVersion") ?? ""
  }

  static var version: String {
    return value(for: "CFBundleShortVersionString") ?? ""
  }

  static var identifier: String {
    return value(for: "CFBundleIdentifier") ?? ""
  }

  static var verBuild: String {
    return "v\(version) (\(build))"
  }

  static let isProduction: Bool = {
    #if PRODUCTION
    return true
    #else
    return false
    #endif
  }()

  static let isDevelopment: Bool = {
    #if DEBUG
    return true
    #else
    return false
    #endif
  }()

  static let isSimulator: Bool = {
    #if arch(i386) || arch(x86_64)
    return true
    #else
    return ProcessInfo.processInfo.environment["SIMULATOR_MODEL_IDENTIFIER"] != nil
    #endif
  }()

  static let isiOSAppOnMac: Bool = {
    if #available(iOS 14.0, *) {
      return ProcessInfo.processInfo.isiOSAppOnMac
    }
    return false
  }()

  static let isTestFlight: Bool = {
    return Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"
  }()

  static let isUnitTest: Bool = {
    return ProcessInfo.processInfo.environment["UNITTEST"] == "1"
  }()

  static let isDebuggerAttached: Bool = {
    return getppid() != 1
  }()
}
