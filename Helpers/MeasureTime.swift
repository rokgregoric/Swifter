//
//  MeasureTime.swift
//
//  Created by Rok Gregorič
//  Copyright © 2019 Rok Gregorič. All rights reserved.
//

import QuartzCore

func measureStart() -> Double {
  return CACurrentMediaTime()
}

func measure(_ start: Double, _ text: String) {
  Log.warning(text, (CACurrentMediaTime() - start).formatted(to: 3), context: "measure time")
}

func measure(_ text: String, block: () -> Void) {
  let start = measureStart()
  block()
  measure(start, text)
}
