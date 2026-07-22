//
//  ConditionalModifier.swift
//
//  Copyright © 2018 Rok Gregorič. All rights reserved.
//

import SwiftUI

extension View {
  @ViewBuilder
  func modify<ModifiedContent: View>(
    if condition: Bool = true,
    @ViewBuilder transform: (Self) -> ModifiedContent
  ) -> some View {
    if condition {
      transform(self)
    } else {
      self
    }
  }
}
