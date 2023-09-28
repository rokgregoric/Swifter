//
//  NSAlertExtensions.swift
//
//  Created by Rok Gregorič
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

import AppKit

extension NSAlert {
  static func show(title: String, message: String, accept: String = "Ok", on window: NSWindow? = nil, completion: (() -> Void)? = nil) {
    let a = NSAlert()
    a.messageText = title
    a.informativeText = message
    a.addButton(withTitle: accept)
    a.alertStyle = .warning
    a.present(on: window) { _ in
      completion?()
    }
  }

  static func ask(title: String, message: String, accept: String = "Yes", decline: String = "No", on window: NSWindow? = nil, destructive: Bool = false, completion: @escaping (Bool) -> Void) {
    let a = NSAlert()
    a.messageText = title
    a.informativeText = message
    if destructive {
      a.addButton(withTitle: decline).keyEquivalent = ""
      a.addButton(withTitle: accept).hasDestructiveAction = true
    } else {
      a.addButton(withTitle: accept)
      a.addButton(withTitle: decline)
    }
    a.alertStyle = .warning
    a.present(on: window) {
      if destructive {
        completion($0 == .alertSecondButtonReturn)
      } else {
        completion($0 == .alertFirstButtonReturn)
      }
    }
  }

  func present(on window: NSWindow? = nil, completion: @escaping (NSApplication.ModalResponse) -> Void) {
    var window: NSWindow! = window
    if window.isNil {
      window = NSWindow(contentRect: .zero, styleMask: .borderless, backing: .buffered, defer: false)
      window.center()
    }
    beginSheetModal(for: window, completionHandler: completion)
    NSApp.activate(ignoringOtherApps: true)
  }
}
