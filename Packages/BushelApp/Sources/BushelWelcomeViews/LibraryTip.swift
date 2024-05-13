//
// LibraryTip.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(TipKit)
  import BushelLocalization
  import Foundation
  import TipKit

  @available(*, unavailable)
  struct LibraryTip: Tip {
    var title: Text {
      Text(.tipLibraryTitle)
    }

    var message: Text? {
      Text(.tipLibraryMessage)
    }

    var image: Image? {
      Image(systemName: "server.rack")
    }
  }
#endif
