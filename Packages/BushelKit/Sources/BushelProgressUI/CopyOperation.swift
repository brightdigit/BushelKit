//
// CopyOperation.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(Observation) && (os(macOS) || os(iOS))
  import Foundation
  import Observation
  import OSLog

  @Observable
  public final class CopyOperation<ValueType: BinaryInteger & Sendable>: Identifiable, Sendable {
    let sourceURL: URL
    let destinationURL: URL
    public let totalValue: ValueType?
    let timeInterval: TimeInterval
    let getSize: @Sendable (URL) async throws -> ValueType?
    let copyFile: @Sendable (CopyPaths) async throws -> Void
    public var currentValue = ValueType.zero
    var timer: Timer?
    let logger: Logger?

    public var id: URL {
      sourceURL
    }

    public init(
      sourceURL: URL,
      destinationURL: URL,
      totalValue: ValueType?,
      timeInterval: TimeInterval,
      logger: Logger?,
      getSize: @escaping @Sendable (URL) async throws -> ValueType?,
      copyFile: @escaping @Sendable (CopyPaths) async throws -> Void
    ) {
      self.sourceURL = sourceURL
      self.destinationURL = destinationURL
      self.totalValue = totalValue
      self.timeInterval = timeInterval
      self.getSize = getSize
      self.copyFile = copyFile
      self.logger = logger
    }

    private func updateValue(_ currentValue: ValueType) {
      self.currentValue = currentValue
    }

    @MainActor
    private func starTimer() {
      timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { [weak self] timer in
        guard let weakSelf = self else {
          timer.invalidate()
          return
        }

        Task {
          if let currentValue = try await weakSelf.getSize(weakSelf.destinationURL) {
            weakSelf.updateValue(currentValue)
          }
          if let totalValue = weakSelf.totalValue {
            guard weakSelf.currentValue < totalValue else {
              weakSelf.logger?.debug("Copy is complete based on size. Quitting timer.")
              weakSelf.killTimer()
              return
            }
          }
        }
      }
    }

    public func execute() async throws {
      self.logger?.debug("Starting Copy operating")
      await starTimer()
      do {
        try await self.copyFile(.init(fromURL: sourceURL, toURL: destinationURL))
      } catch {
        self.logger?.error("Error Copying: \(error)")
        self.killTimer()
        throw error
      }
      self.logger?.debug("Copy is done. Quitting timer.")
      self.killTimer()
    }

    private func killTimer() {
      timer?.invalidate()
      timer = nil
    }

    deinit {
      self.killTimer()
    }
  }

  extension CopyOperation: ProgressOperation {}

#endif
