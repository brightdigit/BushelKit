//
// VZUnderlyingError.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(Virtualization)
  public import Virtualization

  public protocol VZUnderlyingError {
    var domain: VZError.UnderlyingError.Domain { get }
    var code: VZError.UnderlyingError.Code { get }
  }
#endif
