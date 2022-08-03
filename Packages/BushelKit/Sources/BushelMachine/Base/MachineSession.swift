//
// MachineSession.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/2/22.
//

public protocol MachineSession {
  func begin() async throws
}
