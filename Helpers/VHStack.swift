//
//  VHStack.swift
//
//  Created by Rok Gregorič on 11. 11. 25.
//

import SwiftUI

enum VHStackAlignment {
  case start
  case middle
  case end

  var horizontal: HorizontalAlignment {
    switch self {
    case .start:
      return .leading
    case .middle:
      return .center
    case .end:
      return .trailing
    }
  }

  var vertical: VerticalAlignment {
    switch self {
    case .start:
      return .top
    case .middle:
      return .center
    case .end:
      return .bottom
    }
  }
}

/// A container that arranges its children in either a vertical or horizontal stack based on the `vertical` parameter.
struct VHStack<Content: View>: View {
  let vertical: Bool
  var alignment: VHStackAlignment = .middle
  var spacing: CGFloat?
  @ViewBuilder let content: () -> Content

  var body: some View {
    if vertical {
      VStack(alignment: alignment.horizontal, spacing: spacing, content: content)
    } else {
      HStack(alignment: alignment.vertical, spacing: spacing, content: content)
    }
  }
}
