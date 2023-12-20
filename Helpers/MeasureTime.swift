//
//  MeasureTime.swift
//
//  Created by Rok Gregorič
//  Copyright © 2019 Rok Gregorič. All rights reserved.
//

import QuartzCore

func measureStart() -> Double {
  CACurrentMediaTime()
}

func measureEnd(_ start: Double) -> String {
  (CACurrentMediaTime() - start).formatted(to: 6)
}

func measure(_ start: Double, _ text: String) {
  Log.dev(text, measureEnd(start), context: "measure time")
}

func measure(_ text: String, block: () -> Void) {
  let start = measureStart()
  block()
  measure(start, text)
}
