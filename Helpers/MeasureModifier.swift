//
//  MeasureModifier.swift
//
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

import SwiftUI

struct MeasureModifier: ViewModifier {
  typealias SizeHandler = (CGSize) -> Void
  let onSize: SizeHandler

  func body(content: Content) -> some View {
    content
      .background {
        GeometryReader { geometry in
          Color.clear
            .onAppear {
              onSize(geometry.size)
            }
            .onChange(of: geometry.size) { size in
              onSize(size)
            }
        }
      }
  }
}

extension View {
  func measureSize(_ handler: @escaping MeasureModifier.SizeHandler) -> some View {
    modifier(MeasureModifier(onSize: handler))
  }
}
