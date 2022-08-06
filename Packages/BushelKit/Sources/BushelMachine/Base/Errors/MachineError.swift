//
// MachineError.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/3/22.
//

import Foundation

public enum MachineError: Error {
  case undefinedType(String, Any?)
}