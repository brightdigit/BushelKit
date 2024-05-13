//
// SessionFramable.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

protocol SessionFramable {
  var aspectRatio: CGFloat? { get }
  var toolbarHeight: CGFloat { get }
  var idealWidth: CGFloat { get }
  var minWidth: CGFloat { get }
}

extension SessionFramable {
  #if canImport(SwiftUI)
    var idealWidth: CGFloat {
      MachineScene.idealSessionWidth
    }

    var minWidth: CGFloat {
      MachineScene.minimumWidth
    }
  #endif

  var minHeight: CGFloat? {
    aspectRatio.map { self.minWidth / $0 + toolbarHeight }
  }

  var idealHeight: CGFloat? {
    aspectRatio.map { self.idealWidth / $0 + toolbarHeight }
  }
}
