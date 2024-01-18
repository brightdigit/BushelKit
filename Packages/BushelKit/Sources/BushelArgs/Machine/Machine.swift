//
// Machine.swift
// Copyright (c) 2024 BrightDigit.
//

import ArgumentParser
import Foundation

public struct Machine: ParsableCommand {
  public static let configuration = CommandConfiguration(
    abstract: "A utility for performing maths.",
    subcommands: [Machine.Create.self],
    defaultSubcommand: Machine.Create.self
  )

  public init() {}
}
