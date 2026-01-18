//
//  BaseRequestJSON.swift
//
//  Created by Rok Gregoric on 24/12/2021.
//  Copyright © 2021 Rok Gregoric. All rights reserved.
//

#if canImport(SwifterJSON)
import SwifterJSON

extension BaseRequest {
  func requestJSON(completion: @escaping Block3<JSON, Int?, Error?>) {
    request { data, status, err in Run.main { completion(JSON(data), status, err) } }
  }

  func requestJSON(completion: @escaping Block2<JSON, Int?>) {
    request { data, status, _ in Run.main { completion(JSON(data), status) } }
  }

  func requestJSON(completion: @escaping Block1<JSON>) {
    request { data, _, _ in Run.main { completion(JSON(data)) } }
  }
}
#endif
