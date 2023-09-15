//
// ProgressOperationProperties.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(Observation) && (os(macOS) || os(iOS))
  import Foundation

  public struct ProgressOperationProperties: Identifiable {
    let imageName: String
    let text: any StringProtocol
    let progress: FileOperationProgress<Int>

    public var id: URL {
      progress.id
    }

    public init(imageName: String, text: any StringProtocol, progress: FileOperationProgress<Int>) {
      self.imageName = imageName
      self.text = text
      self.progress = progress
    }
  }

  #if canImport(SwiftUI)
    public extension ProgressOperationView {
      typealias Properties = ProgressOperationProperties
      init(
        _ properties: Properties,
        text: @escaping (FileOperationProgress<Int>) -> ProgressText,
        image: @escaping (String) -> Icon
      ) {
        self.init(progress: properties.progress, title: properties.text, text: text) {
          image(properties.imageName)
        }
      }
    }
  #endif

#endif
