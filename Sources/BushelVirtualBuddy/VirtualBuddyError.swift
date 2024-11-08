//
//  VirtualBuddyError.swift
//  BushelKit
//
//  Created by Leo Dion on 11/8/24.
//

public import Foundation



public enum VirtualBuddyError : Error {
  case unsupportedURL(URL)
  case networkError(Error)
  case decodingError(Error)
}
