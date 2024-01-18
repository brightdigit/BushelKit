//
// VZUnderlyingNSError.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(Virtualization)
  import Virtualization

  struct VZUnderlyingNSError: VZUnderlyingError {
    let domain: VZError.UnderlyingError.Domain

    let code: VZError.UnderlyingError.Code

    init(domain: VZError.UnderlyingError.Domain, code: VZError.UnderlyingError.Code) {
      self.domain = domain
      self.code = code
    }

    init?(error: NSError) {
      guard let domain = VZError.UnderlyingError.Domain(rawValue: error.domain) else {
        return nil
      }

      guard let code = VZError.UnderlyingError.Code(rawValue: error.code) else {
        return nil
      }
      self.init(domain: domain, code: code)
    }
  }
#endif
