//
// WelcomeRecentDocumentsView.swift
// Copyright (c) 2022 BrightDigit.
//

#if canImport(SwiftUI)
  import SwiftUI

  struct WelcomeRecentDocumentsView: View {
    @EnvironmentObject var object: RecentDocumentsObject
    var body: some View {
      List {
        ForEach(object.recentDocumentURLs, id: \.self) { url in
          Button {
            Windows.openDocumentAtURL(url)
          } label: {
            HStack {
              Image(nsImage: NSWorkspace.shared.icon(forFile: url.path))
              VStack(alignment: .leading) {
                Text(
                  url
                    .deletingPathExtension()
                    .lastPathComponent
                )
                .font(.custom("Raleway", size: 14.0))
                .fontWeight(.medium)
                Text(url.path).font(.custom("Raleway", size: 14.0)).fontWeight(.ultraLight)
              }.foregroundColor(.primary)
              Spacer()
            }
          }.buttonStyle(BorderlessButtonStyle())
        }
      }.listStyle(SidebarListStyle()).padding(-20)
    }
  }

  struct WelcomeRecentDocumentsView_Previews: PreviewProvider {
    static var previews: some View {
      WelcomeRecentDocumentsView().environmentObject(RecentDocumentsObject(recentDocumentURLs: [
        .init(fileURLWithPath: "/Volumes/Media/hello copy.bshvm"),
        .init(fileURLWithPath: "/Volumes/Media/RestoreImages.bshrilib")
      ], isPreview: true))
    }
  }
#endif