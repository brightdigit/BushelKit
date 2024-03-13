//
// MachineNameListRequest.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftData)
  import BushelMachineData
  import BushelMessageCore

  public struct MachineNameListRequest: Message {
    public typealias ResponseType = [String]
    public init() {}
    public func run(from service: any BushelMessageCore.ServiceInterface) async throws -> [String] {
      try await service.database.fetch(MachineEntry.self).map { entry in
        entry.name
      }
    }
  }
#endif
