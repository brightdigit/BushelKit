//
// LibraryObject+Components.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelData
  import BushelLibrary
  import BushelProgressUI
  import DataThespian
  import Foundation
  import SwiftData

  extension LibraryObject {
    internal struct Components {
      internal let library: Library
      internal let model: ModelID<LibraryEntry>
      internal let database: any Database
      internal let system: any LibrarySystemManaging
    }
  }
#endif
