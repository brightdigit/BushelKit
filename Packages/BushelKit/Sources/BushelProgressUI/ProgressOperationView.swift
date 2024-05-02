//
// ProgressOperationView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelAccessibility
  import SwiftUI

  public struct ProgressOperationView<Icon: View, ProgressText: View>: View {
    let progress: FileOperationProgress<Int>
    let title: any StringProtocol
    let text: (FileOperationProgress<Int>) -> ProgressText
    let icon: () -> Icon

    public var body: some View {
      VStack {
        HStack {
          icon().accessibilityIdentifier(Progress.icon.identifier)
          VStack(alignment: .leading) {
            Text(title)
              .lineLimit(1)
              .font(.title)
              .accessibilityIdentifier(Progress.title.identifier)
              .accessibilityLabel(title)
            HStack {
              if let totalValue = progress.totalValue {
                ProgressView(value: progress.currentValue, total: totalValue)
              } else {
                ProgressView(value: progress.currentValue)
              }
            }
            .accessibilityIdentifier(Progress.view.identifier)
            text(progress)
          }
        }
      }.padding()
    }

    public init(
      progress: FileOperationProgress<Int>,
      title: any StringProtocol,
      text: @escaping (FileOperationProgress<Int>) -> ProgressText,
      icon: @escaping () -> Icon
    ) {
      self.progress = progress
      self.title = title
      self.text = text
      self.icon = icon
    }
  }
#endif
