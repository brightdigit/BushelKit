//
// VZError+UnderlyingError.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(Virtualization)
  public import Virtualization

  extension VZError {
    public enum UnderlyingError {
      public enum Domain: String {
        case mobileDeviceRestore = "com.apple.MobileDevice.MobileRestore"
      }

      public enum Code: Int {
        case unauthorizedInstall = 3_194
      }
    }
  }
#endif
