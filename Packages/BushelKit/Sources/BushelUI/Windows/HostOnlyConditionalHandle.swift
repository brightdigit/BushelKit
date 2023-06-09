//
// HostOnlyConditionalHandle.swift
// Copyright (c) 2023 BrightDigit.
//

protocol HostOnlyConditionalHandle: WindowOpenHandle {}

// extension HostOnlyConditionalHandle where Self: InstanceConditionalHandle {
//  var conditions: Set<String> {
//    [String([Configuration.scheme, host].joined(separator: "://"))]
//  }
// }

extension HostOnlyConditionalHandle where Self: StaticConditionalHandle {
  static var conditions: Set<String> {
    [String([Configuration.scheme, host].joined(separator: "://"))]
  }
}
