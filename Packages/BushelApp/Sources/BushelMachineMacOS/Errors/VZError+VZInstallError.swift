//
// VZError+VZInstallError.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(Virtualization)
  import Virtualization

  extension VZError: VZInstallError {
    public var isVZError: Bool {
      true
    }

    public var rawCode: Int {
      self.code.rawValue
    }

    public var underlyingError: (any VZUnderlyingError)? {
      (self.userInfo[NSUnderlyingErrorKey] as? NSError).flatMap(VZUnderlyingNSError.init)
    }

    public func codeMatches(_ code: Code) -> Bool {
      self.code == code
    }
  }
#endif