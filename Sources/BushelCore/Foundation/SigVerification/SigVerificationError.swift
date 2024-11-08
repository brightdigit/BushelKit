//
//  SigVerificationError.swift
//  BushelKit
//
//  Created by Leo Dion on 11/8/24.
//


public enum SigVerificationError : Error {
  case unsupportedSource
  case internalError(Error)
  case notFound
}