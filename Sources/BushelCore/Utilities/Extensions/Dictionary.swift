//
//  Dictionary.swift
//  BushelKit
//
//  Created by Leo Dion on 11/8/24.
//


extension Dictionary {
  @inlinable public init<S>(uniqueValues values: S, keyBy key: @escaping (Value) -> Key) where S : Sequence, S.Element == Value {
    let uniqueKeysWithValues : [(Key,Value)] = values.map{(key($0), $0)}
    self.init(uniqueKeysWithValues: uniqueKeysWithValues)
    
  }
}