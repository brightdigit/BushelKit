//
// RecentDocumentsMenuContent.swift
// Copyright (c) 2022 BrightDigit.
//

#if canImport(SwiftUI)
  import SwiftUI

  struct RecentDocumentsMenuContent: View {
    @EnvironmentObject var object: RecentDocumentsObject

    var body: some View {
      ForEach(object.recentDocumentURLs, id: \.self) { url in
        Button {
          Windows.openDocumentAtURL(url)
        } label: {
          Text(url.lastPathComponent)
          Image(nsImage: NSWorkspace.shared.icon(forFile: url.path))
        }
      }
    }
  }

  struct RecentDocumentsMenuContent_Previews: PreviewProvider {
    static var previews: some View {
      RecentDocumentsMenuContent().environmentObject(RecentDocumentsObject(recentDocumentURLs: [
        .init(fileURLWithPath: "/Volumes/Media/hello copy.bshvm"),
        .init(fileURLWithPath: "/Volumes/Media/RestoreImages.bshrilib")
      ], isPreview: true))
    }
  }
#endif
