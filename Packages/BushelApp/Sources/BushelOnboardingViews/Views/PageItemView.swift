//
// PageItemView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import AVKit
  import BushelLocalization
  import BushelViewsCore
  import SwiftUI

  struct PageItemView: View {
    @Environment(\.nextPage) var nextPage

    let titleID: LocalizedStringID
    let subtitleID: LocalizedStringID
    let messageID: LocalizedStringID
    let nextButtonID: LocalizedStringID

    let avPlayer: AVPlayer

    var body: some View {
      VStack(spacing: 20.0) {
        Text(self.titleID).font(.system(.largeTitle)).fontWeight(.thin)
        Text(self.subtitleID).font(.system(.title3)).fontWeight(.bold)
        Divider().padding(.horizontal, 120)
        Text(self.messageID).padding(.horizontal, 80)
        Divider().padding(.horizontal, 120)
        #if os(macOS)
          Video(using: avPlayer).aspectRatio(1.0, contentMode: .fit).padding(8.0)
        #endif
        Button(action: {
          nextPage()
        }, label: {
          Text(self.nextButtonID).padding(4.0).padding(.horizontal, 40.0)
        }).buttonStyle(.borderedProminent)
      }.padding(.bottom, 20.0).padding(12.0)
    }

    private init(
      titleID: LocalizedStringID,
      subtitleID: LocalizedStringID,
      messageID: LocalizedStringID,
      avPlayer: AVPlayer,
      nextButtonID: LocalizedStringID = .onboardingNextButton
    ) {
      self.titleID = titleID
      self.subtitleID = subtitleID
      self.messageID = messageID
      self.nextButtonID = nextButtonID
      self.avPlayer = avPlayer
    }

    init(
      titleID: LocalizedStringID,
      subtitleID: LocalizedStringID,
      messageID: LocalizedStringID,
      videoResourceName: String,
      videoResourceExtension: String = AVPlayer.defaultResourceFileExtension,
      nextButtonID: LocalizedStringID = .onboardingNextButton
    ) {
      self.init(
        titleID: titleID,
        subtitleID: subtitleID,
        messageID: messageID,
        avPlayer: .resource(videoResourceName, extension: videoResourceExtension),
        nextButtonID: nextButtonID
      )
    }
  }

  extension PageItemView {
    init(_ item: PageItem) {
      self.init(
        titleID: item.titleID,
        subtitleID: item.subtitleID,
        messageID: item.messageID,
        videoResourceName: item.videoResourceName,
        videoResourceExtension: item.videoResourceExtension,
        nextButtonID: item.nextButtonID
      )
    }
  }

//  #Preview {
//    PageItemView()
//  }
#endif
