//
// Typeface.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

// MARK: - Typeface

public struct Typeface: Codable, Equatable, Sendable {
  enum CodingKeys: String, CodingKey {
    case name = "_name"
    case copyProtected = "copy_protected"
    case copyright
    case designer
    case duplicate
    case embeddable
    case enabled
    case family
    case fullname
    case outline
    case style
    case trademark
    case unique
    case valid
    case vendor
    case version
    case description
  }

  public let name: String
  public let copyProtected: PrivateFramework
  public let copyright: String
  public let designer: String?
  public let duplicate: PrivateFramework
  public let embeddable: PrivateFramework
  public let enabled: PrivateFramework
  public let family: String
  public let fullname: String
  public let outline: PrivateFramework
  public let style: String
  public let trademark: String?
  public let unique: String
  public let valid: PrivateFramework
  public let vendor: String?
  public let version: String
  public let description: String?

  // swiftlint:disable:next line_length
  public init(name: String, copyProtected: PrivateFramework, copyright: String, designer: String?, duplicate: PrivateFramework, embeddable: PrivateFramework, enabled: PrivateFramework, family: String, fullname: String, outline: PrivateFramework, style: String, trademark: String?, unique: String, valid: PrivateFramework, vendor: String?, version: String, description: String?) {
    self.name = name
    self.copyProtected = copyProtected
    self.copyright = copyright
    self.designer = designer
    self.duplicate = duplicate
    self.embeddable = embeddable
    self.enabled = enabled
    self.family = family
    self.fullname = fullname
    self.outline = outline
    self.style = style
    self.trademark = trademark
    self.unique = unique
    self.valid = valid
    self.vendor = vendor
    self.version = version
    self.description = description
  }
}
