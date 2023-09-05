//
// CopyOperation.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(Observation) && os(macOS)
  import Foundation
  import Observation

  extension CopyOperation: ProgressOperation {}

  @Observable
  public class CopyOperation<ValueType: BinaryInteger>: Identifiable {
    @MainActor
    private func starTimer() {
      timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { [weak self] timer in
        guard let weakSelf = self else {
          // Self.logger.warning("Object no longer exists. Quitting timer.")
          timer.invalidate()
          return
        }
        let attributes: [FileAttributeKey: Any]?
        do {
          attributes = try self?.fileManager.attributesOfItem(atPath: weakSelf.destinationURL.path(percentEncoded: false))
        } catch {
          // Self.logger.error("Unable to get current filesize of: \(weakSelf.destinationURL)")
          attributes = nil
        }
        if let currentValue = attributes?[.size] as? ValueType {
          self?.currentValue = currentValue
        }
        if let totalValue = weakSelf.totalValue {
          guard weakSelf.currentValue < totalValue else {
            // Self.logger.debug("Copy is complete based on size. Quitting timer.")
            weakSelf.killTimer()
            return
          }
        }
      }
    }

    public func execute() async throws {
      await starTimer()
      return try await withCheckedThrowingContinuation { continuation in
        do {
          try self.fileManager.copyItem(at: self.sourceURL, to: self.destinationURL)
        } catch {
          self.killTimer()
          continuation.resume(throwing: error)
          return
        }
        // Self.logger.debug("Copy is done. Quitting timer.")
        self.killTimer()

        continuation.resume()
      }
    }

    internal init(fileManager: FileManager, sourceURL: URL, destinationURL: URL, totalValue: ValueType?, timeInterval: TimeInterval = 1.0) {
      assert(sourceURL.isFileURL)
      self.fileManager = fileManager
      self.sourceURL = sourceURL
      self.destinationURL = destinationURL
      self.totalValue = totalValue
      self.timeInterval = timeInterval
    }

    private func killTimer() {
      timer?.invalidate()
      timer = nil
    }

    public var id: URL {
      sourceURL
    }

    let sourceURL: URL
    let destinationURL: URL
    public let totalValue: ValueType?
    let timeInterval: TimeInterval
    let fileManager: FileManager
    public var currentValue = ValueType.zero
    var timer: Timer?

    deinit {
      self.killTimer()
    }
  }

  internal extension CopyOperation where ValueType == Int {
    convenience init(fileManager: FileManager, sourceURL: URL, destinationURL: URL, timeInterval: TimeInterval = 1.0) throws {
      let attributes = try fileManager.attributesOfItem(atPath: sourceURL.path())
      let totalValue = attributes[.size] as? Int
      assert(totalValue != nil)

      self.init(fileManager: fileManager, sourceURL: sourceURL, destinationURL: destinationURL, totalValue: totalValue, timeInterval: timeInterval)
    }
  }

#endif
