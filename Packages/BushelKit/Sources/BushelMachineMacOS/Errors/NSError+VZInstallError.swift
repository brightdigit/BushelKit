//
// NSError+VZInstallError.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(Virtualization)
  import Foundation
  import Virtualization

  extension NSError: VZInstallError {
    var isVZError: Bool {
      self.domain == VZErrorDomain
    }

    var rawCode: Int {
      self.code
    }

    var underlyingError: VZUnderlyingError? {
      (self.userInfo[NSUnderlyingErrorKey] as? NSError).flatMap(VZUnderlyingNSError.init)
    }

    func codeMatches(_ code: VZError.Code) -> Bool {
      self.code == code.rawValue
    }
  }
#endif
