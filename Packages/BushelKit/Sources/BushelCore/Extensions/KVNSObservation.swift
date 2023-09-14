//
// KVNSObservation.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(ObjectiveC)
  import Foundation

  internal class KVNSObservation: KVObservation {
    let observed: NSObject
    let observer: NSObject
    let keyPaths: [String]

    internal init(observed: NSObject, observer: NSObject, keyPaths: [String]) {
      self.observed = observed
      self.observer = observer
      self.keyPaths = keyPaths
    }

    deinit {
      for keyPath in keyPaths {
        observed.removeObserver(observer, forKeyPath: keyPath)
      }
    }
  }
#endif
