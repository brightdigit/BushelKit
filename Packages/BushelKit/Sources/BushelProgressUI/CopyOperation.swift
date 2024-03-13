//
// CopyOperation.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(Observation) && (os(macOS) || os(iOS))
  import BushelCore
  import Foundation
  import Observation
  import OSLog

  @Observable
  public final class CopyOperation<ValueType: BinaryInteger & Sendable>: Identifiable, Sendable {
    let sourceURL: URL
    let destinationURL: URL
    public let totalValue: ValueType?
    let timeInterval: TimeInterval
    let fileManager: any FileHandler
    public var currentValue = ValueType.zero
    var timer: Timer?
    let logger: Logger?

    public var id: URL {
      sourceURL
    }

    internal init(
      fileManager: any FileHandler,
      sourceURL: URL,
      destinationURL: URL,
      totalValue: ValueType?,
      timeInterval: TimeInterval = 1.0,
      logger: Logger? = nil
    ) {
      assert(sourceURL.isFileURL)
      self.fileManager = fileManager
      self.sourceURL = sourceURL
      self.destinationURL = destinationURL
      self.totalValue = totalValue
      self.timeInterval = timeInterval
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
          let attributes: (any AttributeSet)?
          do {
            attributes = try await weakSelf.fileManager.attributesAt(weakSelf.destinationURL)
            // attributes = try weakSelf.fileManager
            // .attributesOfItem(atPath: weakSelf.destinationURL.path(percentEncoded: false))

          } catch {
            weakSelf.logger?.error("Unable to get current filesize of: \(weakSelf.destinationURL)")
            attributes = nil
          }
          if let currentValue: ValueType = attributes?.get(.size) {
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
        try await self.fileManager.copy(at: self.sourceURL, to: self.destinationURL)
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

  internal extension CopyOperation where ValueType == Int {
    convenience init(
      fileManager: @Sendable @escaping () -> FileManager,
      sourceURL: URL,
      destinationURL: URL,
      timeInterval: TimeInterval = 1.0,
      logger: Logger? = nil
    ) throws {
      let attributes = try fileManager().attributesOfItem(atPath: sourceURL.path())
      let totalValue = attributes[.size] as? Int
      let fileHandler = FileManagerHandler(fileManager: fileManager)
      assert(totalValue != nil)

      self.init(
        fileManager: fileHandler,
        sourceURL: sourceURL,
        destinationURL: destinationURL,
        totalValue: totalValue,
        timeInterval: timeInterval,
        logger: logger
      )
    }
  }

  extension CopyOperation: ProgressOperation {}

#endif
