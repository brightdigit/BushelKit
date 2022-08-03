//
// BasicWindowOpenHandle.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/2/22.
//

enum BasicWindowOpenHandle: String, CaseIterable, WindowOpenHandle {
  case machine
  case localImages
  case remoteSources
  case welcome

  var path: String {
    rawValue
  }
}
