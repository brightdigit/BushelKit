//
// ProgressOperationView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelLocalization
  import BushelProgressUI
  import Foundation
  import SwiftUI

  extension ProgressOperationView {
    init(
      _ properties: Properties,
      image: @escaping (String) -> Icon
    ) where ProgressText == Group<Text?> {
      self.init(properties, localizedStringID: .operationProgressText, image: image)
    }

    init(
      _ properties: Properties,
      localizedStringID: LocalizedStringID,
      image: @escaping (String) -> Icon
    ) where ProgressText == Group<Text?> {
      self.init(
        properties
      ) { progress in
        Group {
          if
            let totalValueBytes = progress.totalValueBytes,
            let percentValue = progress.operation.percentValue() {
            Text(
              localizedUsingID: localizedStringID,
              arguments:
              ByteCountFormatter.file.string(fromByteCount: progress.currentValueBytes),
              ByteCountFormatter.file.string(fromByteCount: totalValueBytes),
              percentValue
            )
          }
        }
      } image: {
        image($0)
      }
    }
  }
#endif
