//
// WindowOpenHandle.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/2/22.
//

protocol WindowOpenHandle {
  var path: String { get }
}

extension WindowOpenHandle {
  var basic: BasicWindowOpenHandle.Type {
    BasicWindowOpenHandle.self
  }
}
