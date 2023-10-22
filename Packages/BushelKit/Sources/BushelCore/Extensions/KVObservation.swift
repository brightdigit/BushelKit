//
// KVObservation.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(ObjectiveC)
  import Foundation

  public protocol KVObservation: AnyObject {}

  #warning("logging-note: what useful logging to do in this file?")
  extension NSObject {
    public static func getAllPropertyKeys() -> [String] {
      Self.getAllPropertyKeys(of: Self.self)
    }

    private static func getAllPropertyKeys<ClassType: AnyObject>(of _: ClassType.Type) -> [String] {
      let classType: AnyClass = ClassType.self
      return self.getAllPropertyKeys(of: classType)
    }

    private static func getAllPropertyKeys(of classType: AnyClass) -> [String] {
      var count: UInt32 = 0
      let properties = class_copyPropertyList(classType, &count)
      var propertyKeys: [String] = []

      for index in 0 ..< Int(count) {
        if
          let property = properties?[index],
          let propertyName = String(utf8String: property_getName(property)) {
          propertyKeys.append(propertyName)
        }
      }

      free(properties)
      return propertyKeys
    }

    public func addObserver(
      _ observer: NSObject,
      options: NSKeyValueObservingOptions,
      _ isIncluded: @escaping (String) -> Bool = { _ in true }
    ) -> KVObservation {
      let propertyKeys = self.getAllPropertyKeys().filter(isIncluded)
      return self.addObserver(observer, forKeyPaths: propertyKeys, options: options)
    }

    private func addObserver(
      _ observer: NSObject,
      forKeyPaths keyPaths: [String],
      options: NSKeyValueObservingOptions
    ) -> KVObservation {
      for keyPath in keyPaths {
        self.addObserver(observer, forKeyPath: keyPath, options: options, context: nil)
      }

      return KVNSObservation(observed: self, observer: observer, keyPaths: keyPaths)
    }

    private func getAllPropertyKeys() -> [String] {
      let classType: AnyClass = type(of: self)

      return Self.getAllPropertyKeys(of: classType)
    }
  }
#endif
