//
// System.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelHub
import BushelLibrary
import BushelMachine
import Foundation

public protocol System {
  var library: LibrarySystem { get }
  var machine: any MachineSystem { get }
  var hubs: [Hub] { get }
}
