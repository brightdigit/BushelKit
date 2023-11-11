//
// VZError+VZInstallError.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(Virtualization)
  import Virtualization

  extension VZError: VZInstallError {
    var isVZError: Bool {
      true
    }

    var rawCode: Int {
      self.code.rawValue
    }

    var underlyingError: VZUnderlyingError? {
      (self.userInfo[NSUnderlyingErrorKey] as? NSError).flatMap(VZUnderlyingNSError.init)
    }

    func codeMatches(_ code: Code) -> Bool {
      self.code == code
    }
  }
#endif
