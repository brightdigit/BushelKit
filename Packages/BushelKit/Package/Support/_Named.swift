//
// _Named.swift
// Copyright (c) 2024 BrightDigit.
//

protocol _Named {
  var name: String { get }
}

extension _Named {
  var name: String {
    "\(Self.self)"
  }
}
