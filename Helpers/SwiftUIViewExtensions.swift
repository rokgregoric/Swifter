//
//  SwiftUIViewExtensions.swift
//
//  Created by Rok Gregorič.
//

import SwiftUI

extension View {
  func frame(all dimension: CGFloat) -> some View {
    frame(width: dimension, height: dimension)
  }

  func frame(size: CGSize) -> some View {
    frame(width: size.width, height: size.height)
  }

  func fullWidth(alignment: Alignment = .center) -> some View {
    expanded(height: false, alignment: alignment)
  }

  func fullHeight(alignment: Alignment = .center) -> some View {
    expanded(width: false, alignment: alignment)
  }

  func expanded(
    width: Bool = true,
    height: Bool = true,
    alignment: Alignment = .center
  ) -> some View {
    ZStack(alignment: alignment) {
      Color.clear.frame(width: width ? nil : 0, height: height ? nil : 0)
      self
    }
  }

  func singleLine(
    lines: Int = 1,
    minimumScaleFactor: CGFloat = 0.5
  ) -> some View {
    self
      .minimumScaleFactor(minimumScaleFactor)
      .lineLimit(lines)
  }

  @ViewBuilder
  func optionalColorInvert(_ enabled: Bool) -> some View {
    if enabled {
      colorInvert()
    } else {
      self
    }
  }

  #if os(iOS)
    @ViewBuilder
    func presentationHeightDetentIfAvailable(_ height: CGFloat) -> some View {
      if #available(iOS 16.0, *) {
        presentationDetents([.height(height)])
      } else {
        self
      }
    }
  #endif
}

func Spacer(width: CGFloat) -> some View {
  Spacer().frame(width: width)
}

func Spacer(height: CGFloat) -> some View {
  Spacer().frame(height: height)
}
