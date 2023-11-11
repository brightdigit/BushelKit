//
// VZError+UnderlyingError.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(Virtualization)
  import Virtualization

  public extension VZError {
    enum UnderlyingError {
      public enum Domain: String {
        case mobileDeviceRestore = "com.apple.MobileDevice.MobileRestore"
      }

      public enum Code: Int {
        case unauthorizedInstall = 3194
      }
    }
  }
#endif
