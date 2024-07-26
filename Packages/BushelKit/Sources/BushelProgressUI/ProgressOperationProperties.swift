//
//  ProgressOperationProperties.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2024 BrightDigit.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the “Software”), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#if canImport(Observation) && (os(macOS) || os(iOS))
  public import Foundation

  public struct ProgressOperationProperties: Identifiable, Sendable {
    internal let imageName: String
    internal let text: any (StringProtocol & Sendable)
    internal let progress: FileOperationProgress<Int>

    public var id: URL {
      progress.id
    }

    public init(
      imageName: String,
      text: any(StringProtocol & Sendable),
      progress: FileOperationProgress<Int>
    ) {
      self.imageName = imageName
      self.text = text
      self.progress = progress
    }
  }

  #if canImport(SwiftUI)
    extension ProgressOperationView {
      public typealias Properties = ProgressOperationProperties
      public init(
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
