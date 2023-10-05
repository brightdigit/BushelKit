//
// Formatters.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public enum Formatters {
  public static let lastModifiedDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = $0
    return formatter
  }("E, d MMM yyyy HH:mm:ss Z")
}