//
//  KVObservation.swift
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

#if canImport(ObjectiveC)
  public import Foundation

  @available(*, deprecated)
  public protocol KVObservation: AnyObject, Sendable {}

  #warning("logging-note: what useful logging to do in this file?")
  extension NSObject {
    @available(*, deprecated)
    public static func getAllPropertyKeys() -> [String] {
      getAllPropertyKeys(of: Self.self)
    }

    @available(*, deprecated)
    private static func getAllPropertyKeys<ClassType: AnyObject>(of _: ClassType.Type) -> [String] {
      let classType: AnyClass = ClassType.self
      return self.getAllPropertyKeys(of: classType)
    }

    @available(*, deprecated)
    private static func getAllPropertyKeys(of classType: AnyClass) -> [String] {
      var count: UInt32 = 0
      let properties = class_copyPropertyList(classType, &count)
      var propertyKeys: [String] = []

      for index in 0..<Int(count) {
        if let property = properties?[index],
          let propertyName = String(utf8String: property_getName(property))
        {
          propertyKeys.append(propertyName)
        }
      }

      free(properties)
      return propertyKeys
    }

    @available(*, deprecated)
    @MainActor
    public func addObserver(
      _ observer: NSObject,
      options: NSKeyValueObservingOptions,
      _ isIncluded: @escaping (String) -> Bool = { _ in true }
    ) -> any KVObservation {
      let propertyKeys = self.getAllPropertyKeys().filter(isIncluded)
      return self.addObserver(observer, forKeyPaths: propertyKeys, options: options)
    }

    @available(*, deprecated)
    @MainActor
    private func addObserver(
      _ observer: NSObject,
      forKeyPaths keyPaths: [String],
      options: NSKeyValueObservingOptions
    ) -> any KVObservation {
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
