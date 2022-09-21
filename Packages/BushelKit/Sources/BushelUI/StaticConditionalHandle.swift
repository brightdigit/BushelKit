//
// StaticConditionalHandle.swift
// Copyright (c) 2022 BrightDigit.
//

protocol StaticConditionalHandle: WindowOpenHandle {
  static var conditions: Set<String> { get }
  static var host: String { get }
}

extension StaticConditionalHandle {
  static func host<HandleType: StaticConditionalHandle>(of _: HandleType) -> String {
    HandleType.host
  }

  static func path<HandleType: StaticConditionalHandle>(of handle: HandleType) -> String? {
    handle.path
  }
}
