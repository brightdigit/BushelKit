//
// BushelCommand.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelCommand: Target, Product {
  var name: String {
    "bushel"
  }

  var dependencies: any Dependencies {
    BushelArgs()
  }

  var productType: ProductType {
    .executable
  }
}
