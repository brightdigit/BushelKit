//
// MachineNameListRequest.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftData)
  import BushelMachineData

  public import BushelMessageCore
  import SwiftData

  public struct MachineNameListRequest: Message {
    public typealias ResponseType = [String]
    public init() {}
    public func run(from service: any BushelMessageCore.ServiceInterface) async throws -> [String] {
      try await service.database.fetch(MachineEntry.self) {
        $0.map(\.name)
      }
    }
  }
#endif
