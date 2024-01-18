//
// Bushel.swift
// Copyright (c) 2024 BrightDigit.
//

import ArgumentParser
import Foundation

enum Bushel {
  static let configuration = CommandConfiguration(
    abstract: "A utility for performing maths.",
    subcommands: [Machine.self, Image.self],
    defaultSubcommand: Machine.self
  )
}
