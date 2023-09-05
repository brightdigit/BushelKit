//
// ProgressOperationProperties.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(Observation) && os(macOS)
  import Foundation

  public struct ProgressOperationProperties: Identifiable {
    public init(imageName: String, text: any StringProtocol, progress: FileOperationProgress<Int>) {
      self.imageName = imageName
      self.text = text
      self.progress = progress
    }

    let imageName: String
    let text: any StringProtocol
    let progress: FileOperationProgress<Int>

    public var id: URL {
      progress.id
    }
  }

  #if canImport(SwiftUI)
    public extension ProgressOperationView {
      typealias Properties = ProgressOperationProperties
      init(_ properties: Properties, _ image: @escaping (String) -> Icon) {
        self.init(progress: properties.progress, text: properties.text) {
          image(properties.imageName)
        }
      }
    }
  #endif

#endif
