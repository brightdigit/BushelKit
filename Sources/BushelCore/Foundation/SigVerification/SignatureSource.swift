//
//  SignatureSource.swift
//  BushelKit
//
//  Created by Leo Dion on 11/8/24.
//

public import Foundation


public enum SignatureSource : Sendable {
  case signatureID(String)
  case operatingSystemVersion(OperatingSystemVersion, String?)
}

extension SignatureSource {
  public static func url(_ url: URL) -> Self? {
    guard url.scheme?.starts(with: "http") != false else {
      return nil
    }
    return .signatureID(url.standardized.description)
  }
  
   
}
