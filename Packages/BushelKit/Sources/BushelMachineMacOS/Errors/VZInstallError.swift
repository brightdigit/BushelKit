//
// VZInstallError.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(Virtualization)
  import BushelMachine
  import Virtualization

  protocol VZInstallError: InstallFailureError {
    var isVZError: Bool { get }
    var rawCode: Int { get }
    var underlyingError: VZUnderlyingError? { get }
    func codeMatches(_ code: VZError.Code) -> Bool
  }

  public extension VZInstallError {
    func installationFailure() -> InstallFailure? {
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
