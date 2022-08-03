//
// Scene.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/2/22.
//

import SwiftUI

extension Scene {
  func windowsHandle(_ handle: BasicWindowOpenHandle) -> some Scene {
    handlesExternalEvents(matching: .init([handle.rawValue]))
  }
}
