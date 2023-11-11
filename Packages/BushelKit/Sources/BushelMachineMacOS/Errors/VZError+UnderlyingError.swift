//
// VZError+UnderlyingError.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(Virtualization)
  import Virtualization

  extension VZError {
    enum UnderlyingError {
      enum Domain: String {
        case mobileDeviceRestore = "com.apple.MobileDevice.MobileRestore"
      }

      enum Code: Int {
        case unauthorizedInstall = 3194
      }
    }
  }
#endif
