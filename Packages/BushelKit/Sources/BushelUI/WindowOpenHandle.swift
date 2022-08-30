//
// WindowOpenHandle.swift
// Copyright (c) 2022 BrightDigit.
//

protocol WindowOpenHandle {
  var path: String? { get }
  static func host(of handle: Self) -> String
  static func path(of handle: Self) -> String?
}

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

protocol HostOnlyConditionalHandle: WindowOpenHandle {}

extension HostOnlyConditionalHandle where Self: InstanceConditionalHandle {
  var conditions: Set<String> {
    [String([Configuration.scheme, host].joined(separator: "://"))]
  }
}

extension HostOnlyConditionalHandle where Self: StaticConditionalHandle {
  static var conditions: Set<String> {
    [String([Configuration.scheme, host].joined(separator: "://"))]
  }
}

//
// extension WindowOpenHandle {
//  var basic: BasicWindowOpenHandle.Type {
//    BasicWindowOpenHandle.self
//  }
// }
