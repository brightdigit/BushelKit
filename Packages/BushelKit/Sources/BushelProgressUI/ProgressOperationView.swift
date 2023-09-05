//
// ProgressOperationView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import SwiftUI

  // swiftlint:disable:next line_length force_unwrapping
  private let previewURL: URL = .init(string: "https://updates.cdn-apple.com/2023SummerFCS/fullrestores/042-25658/2D6BE8DB-5549-4F85-8C54-39FC23BABC68/UniversalMac_13.5.1_22G90_Restore.ipsw")!

  public struct ProgressOperationView<Icon: View>: View {
    public init(indicator: any ProgressOperation<Int>, text: any StringProtocol, icon: @escaping () -> Icon) {
      self.init(progress: .init(indicator), text: text, icon: icon)
    }

    public init(progress: FileOperationProgress<Int>, text: any StringProtocol, icon: @escaping () -> Icon) {
      self.progress = progress
      self.text = text
      self.icon = icon
    }

    let progress: FileOperationProgress<Int>
    let text: any StringProtocol
    let icon: () -> Icon

    public var body: some View {
      VStack {
        HStack {
          icon()
          VStack(alignment: .leading) {
            Text(text).lineLimit(1).font(.title)
            HStack {
              if let totalValue = progress.totalValue {
                ProgressView(value: progress.currentValue, total: totalValue)
              } else {
                ProgressView(value: progress.currentValue)
              }
            }
            HStack {
              Text(
                Int64(progress.currentValueBytes), format: .byteCount(style: .file)
              )
              if let totalValueBytes = self.progress.totalValueBytes {
                Text("/")
                Text(
                  totalValueBytes, format: .byteCount(style: .file)
                )
              }
              if let percentValue = progress.operation.percentValue() {
                Text("(\(percentValue)%)")
              }
            }
          }
        }
      }.padding()
    }
  }

  #Preview {
    ProgressOperationView(
      indicator: PreviewOperation(currentValue: 20, totalValue: 100, id: previewURL),
      text: "Hello World"
    ) {
      Image(systemName: "play")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 80, height: 80)
        .mask {
          Circle()
        }.overlay {
          Circle().stroke()
        }.padding(.horizontal)
    }
  }
#endif
