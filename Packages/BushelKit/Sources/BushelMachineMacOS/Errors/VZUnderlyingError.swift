//
// VZUnderlyingError.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(Virtualization)
  import Virtualization

  public protocol VZUnderlyingError {
    var domain: VZError.UnderlyingError.Domain { get }
    var code: VZError.UnderlyingError.Code { get }
  }
#endif
