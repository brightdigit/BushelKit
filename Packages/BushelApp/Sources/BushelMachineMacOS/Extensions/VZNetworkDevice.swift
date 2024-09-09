//
// VZNetworkDevice.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(Virtualization)
  public import BushelMachine
  import Virtualization

  extension VZNetworkDevice: @retroactive MachineNetworkDevice {}
#endif
