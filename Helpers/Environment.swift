//
//  Environment.swift
//
//  Created by Rok Gregorič
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

import Foundation

struct Environment {
    fileprivate static func valueForKey(_ key: String) -> String {
        return Bundle.main.object(forInfoDictionaryKey: key) as? String ?? ""
    }

    static var appName: String {
        return valueForKey("CFBundleName")
    }

    static var build: String {
        return valueForKey("CFBundleVersion")
    }

    static var version: String {
        return valueForKey("CFBundleShortVersionString")
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

    static let isTestFlight: Bool = {
        return Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"
    }()

    static let isSimulator: Bool = {
        var sim = false
        #if arch(i386) || arch(x86_64)
            sim = true
        #endif
        return sim
    }()
}
