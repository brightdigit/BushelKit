//
// Sequence.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelCore
import BushelLogging

public extension Sequence {
  func tryCompactMap<T>(logger: Logger? = nil, _ transform: (Self.Element) throws -> T) -> [T] {
    self.compactMap { element in
      do {
        return try transform(element)
      } catch {
        assertionFailure(error: error)
        logger?.error("Unable to transform element: \(error.localizedDescription)")
      }
      return nil
    }
  }
}
