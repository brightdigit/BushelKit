//
//  ProgressOperationView.swift
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

#if canImport(SwiftUI)
  public import SwiftUI

  public struct ProgressOperationView<Icon: View, ProgressText: View>: View {
    private let progress: FileOperationProgress<Int>
    private let title: any StringProtocol
    private let text: (FileOperationProgress<Int>) -> ProgressText
    private let icon: () -> Icon

    public var body: some View {
      VStack {
        HStack {
          icon() // .accessibilityIdentifier(Progress.icon.identifier)
          VStack(alignment: .leading) {
            Text(title)
              .lineLimit(1)
              .font(.title)
              // .accessibilityIdentifier(Progress.title.identifier)
              .accessibilityLabel(title)
            HStack {
              if let totalValue = progress.totalValue {
                ProgressView(value: progress.currentValue, total: totalValue)
              } else {
                ProgressView(value: progress.currentValue)
              }
            }
            // .accessibilityIdentifier(Progress.view.identifier)
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
