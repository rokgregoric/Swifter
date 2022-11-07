//
//  OptionalProtocol.swift
//  Closer
//
//  Created by Rok Gregoric on 07/11/2022.
//  Copyright © 2022 Closer Technologies Inc. All rights reserved.
//

import Foundation

protocol OptionalProtocol {
  associatedtype Wrapped
  var val: Wrapped? { get }
}

extension Optional: OptionalProtocol {
  public var val: Wrapped? { self }
  public var isNil: Bool { self == nil }
  public var notNil: Bool { self != nil }
}
