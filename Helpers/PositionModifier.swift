//
//  PositionModifier.swift
//
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

import SwiftUI

struct PositionModifier: ViewModifier {
  typealias PositionHandler = (CGRect) -> Void

  let coordinateSpace: String?
  let onPositionChange: PositionHandler

  func body(content: Content) -> some View {
    content
      .background {
        GeometryReader { geometry in
          Color.clear
            .onAppear {
              onPositionChange(frame(in: geometry))
            }
            .onChange(of: frame(in: geometry)) { frame in
              onPositionChange(frame)
            }
        }
      }
  }

  private func frame(in geometry: GeometryProxy) -> CGRect {
    geometry.frame(in: coordinateSpace.map(CoordinateSpace.named) ?? .global)
  }
}

extension View {
  func trackPosition(
    coordinateSpace: String? = nil,
    _ handler: @escaping PositionModifier.PositionHandler
  ) -> some View {
    modifier(
      PositionModifier(
        coordinateSpace: coordinateSpace,
        onPositionChange: handler
      )
    )
  }
}
