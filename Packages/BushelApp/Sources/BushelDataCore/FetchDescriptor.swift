//
// FetchDescriptor.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftData)
  import Foundation

  import SwiftData

  extension FetchDescriptor {
    internal init(predicate: Predicate<T>? = nil, sortBy: [SortDescriptor<T>] = [], fetchLimit: Int?) {
      self.init(predicate: predicate, sortBy: sortBy)

      self.fetchLimit = fetchLimit
    }
  }
#endif
