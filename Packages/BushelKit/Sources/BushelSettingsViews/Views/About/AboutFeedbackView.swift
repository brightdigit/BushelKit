//
// AboutFeedbackView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelLocalization
  import SwiftUI

  struct AboutFeedbackView: View {
    @Environment(\.openURL) var openURL
    let alignment: HorizontalAlignment
    let spacing: CGFloat
    let titleID: LocalizedStringID
    let detailsID: LocalizedStringID
    let buttonTextID: LocalizedStringID
    let buttonURL: URL
    var body: some View {
      VStack(alignment: .leading, spacing: 6.0) {
        Text(titleID).fontWeight(.bold)
        Text(detailsID).lineLimit(3, reservesSpace: true).fontWidth(.expanded).fontWeight(.thin)
        HStack {
          Spacer()
          Button(openURL, buttonURL) {
            Text(buttonTextID)
          }
        }
      }
    }

    internal init(
      alignment: HorizontalAlignment = .leading,
      spacing: CGFloat = 6.0,
      titleID: LocalizedStringID = .aboutFeedback,
      detailsID: LocalizedStringID = .aboutFeedbackDetails,
      buttonTextID: LocalizedStringID = .contactUs,
      buttonURL: URL
    ) {
      self.alignment = alignment
      self.spacing = spacing
      self.titleID = titleID
      self.detailsID = detailsID
      self.buttonTextID = buttonTextID
      self.buttonURL = buttonURL
    }
  }

#endif
