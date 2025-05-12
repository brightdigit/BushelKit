//
//  SessionOptions.swift
//  BushelKit
//
//  Created by Leo Dion on 5/12/25.
//

import Foundation

public struct SessionOptions: OptionSet, Codable, Hashable, Sendable {
  public var rawValue: Int
  
  public init(rawValue: Int) {
    self.rawValue = rawValue
  }
  
  public static let orphan = SessionOptions(rawValue: 1 << 0)
}
