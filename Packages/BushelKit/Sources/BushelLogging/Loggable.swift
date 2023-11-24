//
// Loggable.swift
// Copyright (c) 2023 BrightDigit.
//

import FelinePine

public protocol Loggable: FelinePine.Loggable where Self.LoggingSystemType == BushelLogging {}
