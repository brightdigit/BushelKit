//
// Loggable.swift
// Copyright (c) 2024 BrightDigit.
//

import protocol FelinePine.Loggable
@_exported import typealias FelinePine.Logger

public protocol Loggable: FelinePine.Loggable where Self.LoggingSystemType == BushelLogging {}
