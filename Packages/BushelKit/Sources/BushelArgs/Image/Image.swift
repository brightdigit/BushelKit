//
// Image.swift
// Copyright (c) 2023 BrightDigit.
//

import ArgumentParser
import Foundation

public struct Image: ParsableCommand {
  public static let configuration = CommandConfiguration(
    abstract: "A utility for performing maths.",
    subcommands: [Image.List.self],
    defaultSubcommand: Image.List.self
  )

  public init() {}
}
