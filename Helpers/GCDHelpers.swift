//
//  GCDHelpers.swift
//
//  Created by Rok Gregorič
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

import Foundation

class Run {
  static func on(_ queue: DispatchQueue, after: Double = 0, _ block: @escaping @convention(block) () -> Void) {
    if after == 0 {
      queue.async(execute: block)
    } else {
      queue.asyncAfter(deadline: .now() + after, execute: block)
    }
  }

  static func main(after: Double = 0, _ block: @escaping () -> Void) {
    on(.main, after: after, block)
  }

  static func background(after: Double = 0, _ block: @escaping () -> Void) {
    on(.global(qos: .background), after: after, block)
  }

  static func concurrent(after: Double = 0, _ block: @escaping () -> Void) {
    on(.global(qos: .userInteractive), after: after, block)
  }

  static func main(min: Double, _ block: @escaping (@escaping () -> Void) -> Void, _ done: @escaping () -> Void) {
    let g = DispatchGroup()
    2.times(g.enter)
    g.notify(queue: .main, execute: done)
    main(after: min, g.leave)
    block(g.leave)
  }
}


class Task {
  fileprivate var block: (() -> Void)?

  init(_ after: Double, _ block: @escaping () -> Void) {
    self.block = block
    Run.main(after: after) { [weak self] in
      self?.run()
    }
  }

  func run() {
    block?()
    block = nil
  }

  var fired: Bool {
    return block == nil
  }
}
