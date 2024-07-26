//
//  CopyOperation.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2024 BrightDigit.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the “Software”), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#if canImport(Observation) && (os(macOS) || os(iOS))
  public import Foundation
  import Observation

  public import OSLog

  @MainActor
  @Observable
  public final class CopyOperation<ValueType: BinaryInteger & Sendable>: Identifiable {
    private let sourceURL: URL
    private let destinationURL: URL
    public let totalValue: ValueType?
    private let timeInterval: TimeInterval
    private nonisolated let getSize: @Sendable (URL) throws -> ValueType?
    private let copyFile: @Sendable (CopyPaths) async throws -> Void
    public var currentValue = ValueType.zero
    private var timer: Timer?
    private let logger: Logger?

    public nonisolated var id: URL {
      sourceURL
    }

    public init(
      sourceURL: URL,
      destinationURL: URL,
      totalValue: ValueType?,
      timeInterval: TimeInterval,
      logger: Logger?,
      getSize: @escaping @Sendable (URL) throws -> ValueType?,
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

    private nonisolated func updateValue(_ currentValue: ValueType) {
      Task {
        await self.updatingValue(currentValue)
      }
    }

    private func updatingValue(_ currentValue: ValueType) {
      self.currentValue = currentValue
      if let totalValue = self.totalValue {
        guard self.currentValue < totalValue else {
          self.logger?.debug("Copy is complete based on size. Quitting timer.")
          self.killTimer()
          return
        }
      } else {
        self.logger?.warning("Total size is missing")
      }
    }

    private func starTimer() {
      timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { [weak self] timer in
        guard let weakSelf = self else {
          timer.invalidate()
          return
        }
        weakSelf.logger?.debug("Timer On")
        assert(weakSelf.logger != nil)
        Task {
          let currentValue: ValueType?
          do {
            currentValue = try await weakSelf.getSize(weakSelf.destinationURL)
          } catch {
            weakSelf.logger?.error("Unable to get size: \(error)")
            assertionFailure("Unable to get size: \(error)")
            currentValue = nil
          }
          if let currentValue {
            weakSelf.updateValue(currentValue)
            weakSelf.logger?.debug("Updating size to: \(currentValue)")
          } else {
            weakSelf.logger?.warning("Unable to get size")
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
  }

  extension CopyOperation: ProgressOperation {}

#endif
