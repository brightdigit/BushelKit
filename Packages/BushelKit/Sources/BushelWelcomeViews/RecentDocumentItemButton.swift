//
// RecentDocumentItemButton.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI) && os(macOS)
  import BushelAccessibility
  import SwiftUI

  struct RecentDocumentItemButton: View {
    let document: RecentDocument
    @Environment(\.openWindow) var openWindow
    @Environment(\.openFileURL) var openFileURL
    var body: some View {
      Button {
        openFileURL(document.url, with: openWindow)
      } label: {
        HStack {
          Image(nsImage: NSWorkspace.shared.icon(forFile: document.path))
          VStack(alignment: .leading) {
            Text(document.name)
              .font(.system(size: 12.0))
              .fontWeight(.medium)
              .lineLimit(1)
              .multilineTextAlignment(.leading)
            Text(document.text)
              .font(.system(size: 10.0))
              .fontWeight(.ultraLight)
              .lineLimit(1)
          }.foregroundColor(.primary)
          Spacer()
        }
        .padding(.trailing)
      }
      .buttonStyle(BorderlessButtonStyle())
      .accessibilityLabel(document.name)
      .accessibilityIdentifier(document.path)
    }
  }
#endif
