//
// WindowOpenHandle.swift
// Copyright (c) 2023 BrightDigit.
//

protocol WindowOpenHandle {
  var path: String? { get }
  static func host(of handle: Self) -> String
  static func path(of handle: Self) -> String?
}
