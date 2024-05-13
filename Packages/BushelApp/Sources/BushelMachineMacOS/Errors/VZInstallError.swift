//
// VZInstallError.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(Virtualization)
  import BushelMachine
  import Virtualization

  public protocol VZInstallError: InstallFailureError {
    var isVZError: Bool { get }
    var rawCode: Int { get }
    var underlyingError: (any VZUnderlyingError)? { get }
    func codeMatches(_ code: VZError.Code) -> Bool
  }

  extension VZInstallError {
    public func installationFailure() -> InstallFailure? {
      guard self.isVZError else {
        return nil
      }

      guard let underlyingError = self.underlyingError else {
        return nil
      }
      guard
        underlyingError.domain == .mobileDeviceRestore,
        underlyingError.code == .unauthorizedInstall else {
        return nil
      }
      return .init(
        errorDomain: VZErrorDomain,
        errorCode: self.rawCode,
        failureCode: underlyingError.code.rawValue,
        description: "This Restore Image is not authorized to be installed.",
        isSystem: false
      )
    }
  }
#endif