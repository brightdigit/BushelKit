//
// Formatters.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public enum Formatters {
  #if os(macOS)
    public static let seconds: DateComponentsFormatter = {
      let secondsFormatter = DateComponentsFormatter()
      secondsFormatter.allowedUnits = [.minute, .second]
      secondsFormatter.zeroFormattingBehavior = .dropAll
      secondsFormatter.allowsFractionalUnits = true
      secondsFormatter.unitsStyle = .abbreviated
      return secondsFormatter
    }()
  #endif

  public static let lastModifiedDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = $0
    return formatter
  }("E, d MMM yyyy HH:mm:ss Z")

  public static let snapshotDateFormatter = {
    var formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .medium
    return formatter
  }()

  public static let longDate: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .long
    dateFormatter.timeStyle = .none
    return dateFormatter
  }()
}
