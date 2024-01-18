//
// AboutFeedbackView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI) && os(macOS)
  import BushelLocalization
  import BushelOnboardingEnvironment
  import BushelViewsCore
  import SwiftUI

  @available(iOS 16.0, visionOS 1.0, macOS 13.0, *)
  struct AboutFeedbackView: View {
    @State var isAdvancedButtonsVisible: Bool = true
    @Environment(\.openURL) var openURL
    @Environment(\.openWindow) var openWindow
    @Environment(\.requestReview) var requestReview
    @Environment(\.onboardingWindow) var onboardingWindow
    @Environment(\.purchaseWindow) var purchaseWindow
    let alignment: HorizontalAlignment
    let spacing: CGFloat
    let titleID: LocalizedStringID
    let detailsID: LocalizedStringID
    let buttonTextID: LocalizedStringID
    let buttonURL: URL
    var body: some View {
      VStack(alignment: .leading, spacing: 6.0) {
        Text(titleID).fontWeight(.bold)
        Text(detailsID).lineLimit(3, reservesSpace: true)
        HStack {
          Spacer()
          Button("More Actions") {
            self.isAdvancedButtonsVisible.toggle()
          }.keyboardShortcut(KeyEquivalent("b"), modifiers: [.command, .option, .control])
            .opacity(0.0)
          Button("See Subscription Page") {
            self.openWindow(value: self.purchaseWindow)
          }.isHidden(self.isAdvancedButtonsVisible)
          Button(.menuOnboarding) {
            self.openWindow(value: onboardingWindow)
          }.isHidden(self.isAdvancedButtonsVisible)
          Button(.requestReview) {
            self.requestReview()
          }.isHidden(self.isAdvancedButtonsVisible)
          Button(openURL, buttonURL) {
            Image(systemName: "envelope.fill")
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
