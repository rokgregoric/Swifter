//
//  GCDHelpers.swift
//
//  Created by Rok Gregorič
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

import Foundation

typealias Block = () -> Void
typealias Block1<I> = (I) -> Void
typealias Block2<I, J> = (I, J) -> Void
typealias Block3<I, J, K> = (I, J, K) -> Void

class Run {
  static func on(_ queue: DispatchQueue, after: Double = 0, _ block: @escaping @convention(block) () -> Void) {
    if after == 0 {
      queue.async(execute: block)
    } else {
      queue.asyncAfter(deadline: .now() + after, execute: block)
    }
  }

  static func mainSync(after: Double = 0, _ block: @escaping Block) {
    if Thread.isMainThread, after == 0 {
      block()
    } else {
      main(after: after, block)
    }
  }

  static func main(after: Double = 0, _ block: @escaping Block) {
    on(.main, after: after, block)
  }

  static func background(after: Double = 0, _ block: @escaping Block) {
    on(.global(qos: .background), after: after, block)
  }

  static func concurrent(after: Double = 0, _ block: @escaping Block) {
    on(.global(qos: .userInteractive), after: after, block)
  }

  static func main(min: Double, _ block: @escaping (@escaping Block) -> Void, _ done: @escaping Block) {
    let g = DispatchGroup()
    2.times(g.enter)
    g.notify(queue: .main, execute: done)
    main(after: min, g.leave)
    block(g.leave)
  }
}

class RunTask {
  private var block: Block?
  private let queue: DispatchQueue

  init(_ after: Double, queue: DispatchQueue = .main, _ block: @escaping Block) {
    self.queue = queue
    self.block = block
    Run.on(queue, after: after) { [weak self] in
      self?.run()
    }
  }

  func run() {
    guard let b = block else { return }
    block = nil
    Run.on(queue, b)
  }

  var fired: Bool { block == nil }
}
