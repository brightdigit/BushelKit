//
// MachineSystemBuilder.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

@resultBuilder
public enum MachineSystemBuilder {
  public static func buildBlock(_ components: any MachineSystem ...) -> [any MachineSystem] {
    components
  }
}
