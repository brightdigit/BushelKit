//
// InstanceConditionalHandle.swift
// Copyright (c) 2022 BrightDigit.
//

protocol InstanceConditionalHandle: WindowOpenHandle {
  var conditions: Set<String> { get }
  var host: String { get }
}

extension InstanceConditionalHandle {
  static func host<HandleType: InstanceConditionalHandle>(of handle: HandleType) -> String {
    handle.host
  }

  static func path<HandleType: InstanceConditionalHandle>(of handle: HandleType) -> String? {
    handle.path
  }
}
