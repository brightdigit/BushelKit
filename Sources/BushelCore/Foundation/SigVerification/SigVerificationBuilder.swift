//
//  SigVerificationBuilder.swift
//  BushelKit
//
//  Created by Leo Dion on 11/8/24.
//


@resultBuilder
public enum SigVerificationBuilder {
  public static func buildBlock(_ components: any SigVerifier...) -> [any SigVerifier] {
    components
  }
}