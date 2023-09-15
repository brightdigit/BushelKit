//
// RecentDocumentItemButton.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI) && os(macOS)
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
            Text(
              document.name
            )
            .font(.system(size: 12.0))
            .fontWeight(.medium)
            Text(document.text).font(.system(size: 10.0)).fontWeight(.ultraLight).lineLimit(1)
          }.foregroundColor(.primary)
          Spacer()
        }
      }.buttonStyle(BorderlessButtonStyle())
    }
  }
#endif