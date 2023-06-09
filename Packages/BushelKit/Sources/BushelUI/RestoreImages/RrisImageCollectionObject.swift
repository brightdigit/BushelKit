//
// RrisImageCollectionObject.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelMachine
  import BushelVirtualization
  import Foundation

  class RrisImageCollectionObject: ObservableObject {
    let source: Rris

    @Published var imageListResult: Result<[RestoreImage], Error>?

    init(source: Rris) {
      self.source = source
    }

    func loadImages() {
      Task {
        let result: Result<[RestoreImage], Error>
        do {
          result = try await.success(self.source.fetch())
        } catch {
          result = .failure(error)
        }
        #warning("Swap for MainActor")
        DispatchQueue.main.async {
          self.imageListResult = result
        }
      }
    }
  }
#endif
