//
//  SigVerification.swift
//  BushelKit
//
//  Created by Leo Dion on 11/8/24.
//


public enum SigVerification : Int, Sendable, Codable,  CustomDebugStringConvertible {
  public var debugDescription: String {
    switch self {
    case .signed: return "Signed"
    case .unsigned: return "Unsigned"
    }
  }
  
  case unsigned
  case signed
}


extension SigVerification {
  public init (isSigned: Bool) {
    self = isSigned ? .signed : .unsigned
  }
}
