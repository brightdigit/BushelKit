//
//  SignaturePriority.swift
//  BushelKit
//
//  Created by Leo Dion on 11/8/24.
//


public enum SignaturePriority: Int, Codable, CaseIterable, Sendable {
  case never = -2147483648
  case medium = 0
  case always = 2147483647
}