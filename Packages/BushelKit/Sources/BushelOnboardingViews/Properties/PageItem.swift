//
// PageItem.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelLocalization

struct PageItem: Identifiable {
  let id: String
  let titleID: LocalizedStringID
  let subtitleID: LocalizedStringID
  let messageID: LocalizedStringID
  let nextButtonID: LocalizedStringID // = .onboardingNextButton
  let videoResourceName: String
  let videoResourceExtension: String // = AVPlayer.defaultResourceFileExtension

  internal init(
    titleID: LocalizedStringID,
    subtitleID: LocalizedStringID,
    messageID: LocalizedStringID,
    videoResourceName: String,
    nextButtonID: LocalizedStringID = .onboardingNextButton,
    videoResourceExtension: String = VideoResource.defaultFileExtension,
    id: String? = nil
  ) {
    self.id = id ?? [
      [titleID, subtitleID, messageID, nextButtonID].map(\.rawValue),
      [videoResourceName, videoResourceName]
    ]
    .flatMap { $0 }.joined()
    self.titleID = titleID
    self.subtitleID = subtitleID
    self.messageID = messageID
    self.nextButtonID = nextButtonID
    self.videoResourceName = videoResourceName
    self.videoResourceExtension = videoResourceExtension
  }
}
