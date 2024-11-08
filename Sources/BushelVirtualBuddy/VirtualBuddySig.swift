//
//  VirtualBuddySig.swift
//  BushelKit
//
//  Created by Leo Dion on 11/8/24.
//

public import Foundation


public struct VirtualBuddySig : Codable {
  public let uuid: UUID
  public let version: OperatingSystemVersion
  public let build: String
  public let code: Int
  public let message: String
  public let isSigned: Bool
}
