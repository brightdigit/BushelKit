//
// BushelWelcomeViews.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

struct BushelWelcomeViews: Target {
  var dependencies: any Dependencies {
    BushelData()
    BushelLocalization()
  }
}