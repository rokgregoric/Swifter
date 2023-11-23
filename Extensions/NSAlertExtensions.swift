//
//  NSAlertExtensions.swift
//
//  Created by Rok Gregorič
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

import AppKit

private let dismissIdentifier = NSUserInterfaceItemIdentifier(rawValue: "dismissIdentifier")
private var dismisses = [NSWindow: Block]()

extension NSAlert {
  static func registerESC() {
    NSEvent.addLocalMonitorForEvents(matching: .keyDown) {
      if $0.keyCode == 53 {  // 53 is the Escape key
        for window in NSApplication.shared.windows {
          if window.identifier == dismissIdentifier {
            window.orderOut(nil)
            dismisses[window]?()
            dismisses[window] = nil
          }
        }
      }
      return $0
    }
  }

  static func dismissible(dismiss: Block? = nil) -> NSAlert {
    let a = NSAlert()
    a.window.identifier = dismissIdentifier
    dismisses[a.window] = dismiss
    return a
  }

  private func cancelDismiss() {
    dismisses[window] = nil
  }

  static func show(title: String, message: String, accept: String = "Ok", on window: NSWindow? = nil, completion: Block? = nil, dismiss: Block? = nil) {
    let a = NSAlert.dismissible(dismiss: dismiss)
    a.messageText = title
    a.informativeText = message
    a.addButton(withTitle: accept)
    a.present(on: window) { _ in
      completion?()
      a.cancelDismiss()
    }
  }

  @discardableResult
  static func ask(title: String, message: String, accept: String = "Yes", decline: String = "No", destructive: Bool = false, suppression: Bool = false, on window: NSWindow? = nil, completion: @escaping Block1<Bool>, dismiss: Block? = nil) -> NSAlert {
    let a = NSAlert.dismissible(dismiss: dismiss)
    a.messageText = title
    a.informativeText = message
    if destructive {
      a.addButton(title: decline)
      a.addButton(title: accept).hasDestructiveAction = true
    } else {
      a.addButton(withTitle: accept)
      a.addButton(title: decline)
    }
    a.showsSuppressionButton = suppression
    a.present(on: window) {
      if destructive {
        completion($0 == .alertSecondButtonReturn)
      } else {
        completion($0 == .alertFirstButtonReturn)
      }
      a.cancelDismiss()
    }
    return a
  }

  @discardableResult
  func addButton(title: String) -> NSButton {
    let b = addButton(withTitle: title)
    b.keyEquivalent = title.first.map { "\($0.lowercased())" } ?? ""
    return b
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
