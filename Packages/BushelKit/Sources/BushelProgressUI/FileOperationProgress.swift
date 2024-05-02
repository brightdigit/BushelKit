//
// FileOperationProgress.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(Observation) && (os(macOS) || os(iOS))
  import Foundation
  import Observation

  @Observable
  public final class FileOperationProgress<ValueType: BinaryInteger>: Identifiable, Sendable {
    public let operation: any ProgressOperation<ValueType>

    public var id: URL {
      operation.id
    }

    public var totalValueBytes: Int64? {
      operation.totalValue.map(Int64.init)
    }

    public var currentValueBytes: Int64 {
      Int64(operation.currentValue)
    }

    var currentValue: Double {
      Double(operation.currentValue)
    }

    var totalValue: Double? {
      operation.totalValue.map(Double.init)
    }

    public init(_ operation: any ProgressOperation<ValueType>) {
      self.operation = operation
    }
  }
#endif
