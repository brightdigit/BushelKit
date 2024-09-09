//
// AboutFeedbackView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI) && os(macOS)
  import BushelCore
  import BushelFeatureFlags
  import BushelFeedbackEnvironment
  import BushelLocalization
  import BushelOnboardingEnvironment
  import BushelViewsCore
  import BushelWishListEnvironment
  import SwiftUI

  @available(iOS 16.0, visionOS 1.0, macOS 13.0, *)
  internal struct AboutFeedbackView: View {
    @State var isAdvancedButtonsVisible = true
    @Environment(\.openURL) var openURL
    @Environment(\.openWindow) var openWindow
    @Environment(\.requestReview) var requestReview
    @Environment(\.onboardingWindow) var onboardingWindow
    @Environment(\.purchaseWindow) var purchaseWindow
    @Environment(\.userFeedback) var userFeedback
    @Environment(\.provideFeedback) var provideFeedback
    @Environment(\.wishList) var wishList

    @AppStorage(for: Tracking.Error.self)
    var errorTrackingEnabled

    let alignment: HorizontalAlignment
    let spacing: CGFloat
    let titleID: LocalizedStringID
    let detailsID: LocalizedStringID
    let contactUsTextID: LocalizedStringID
    let contactUsEmailURL: URL
    var body: some View {
      VStack(alignment: .leading, spacing: 6.0) {
        Text(titleID).fontWeight(.bold)
        Text(detailsID).lineLimit(3, reservesSpace: true)
        HStack {
          Group {
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
          }.font(.caption)
          HStack {
            Button {
              self.openWindow(value: self.wishList)
            } label: {
              Image(systemName: "wand.and.stars")
              Text(.menuWishList)
            }
            if userFeedback.value, errorTrackingEnabled {
              Button {
                self.openWindow(value: provideFeedback)
              } label: {
                Image(systemName: "bubble.left.fill")
                Text(.menuProvideFeedback)
              }
            }
            Button(openURL, contactUsEmailURL) {
              Image(systemName: "envelope.fill")
              Text(contactUsTextID)
            }
          }.layoutPriority(1.0)
        }
      }
    }

    internal init(
      alignment: HorizontalAlignment = .leading,
      spacing: CGFloat = 6.0,
      titleID: LocalizedStringID = .aboutFeedback,
      detailsID: LocalizedStringID = .aboutFeedbackDetails,
      contactUsTextID: LocalizedStringID = .contactUs,
      contactUsEmailURL: URL
    ) {
      self.alignment = alignment
      self.spacing = spacing
      self.titleID = titleID
      self.detailsID = detailsID
      self.contactUsTextID = contactUsTextID
      self.contactUsEmailURL = contactUsEmailURL
    }
  }

#endif
