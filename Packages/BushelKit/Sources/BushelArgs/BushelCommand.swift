//
// BushelCommand.swift
// Copyright (c) 2023 BrightDigit.
//

import ArgumentParser
import Foundation

public protocol BushelCommand: ParsableCommand {}

public extension BushelCommand {
  static var configuration: CommandConfiguration {
    Bushel.configuration
  }
}
