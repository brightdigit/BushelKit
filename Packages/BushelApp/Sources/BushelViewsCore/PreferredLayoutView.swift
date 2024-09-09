//
// PreferredLayoutView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import Foundation

  public import SwiftUI

  public struct Value<Value> {
    private let value: Value?

    // swiftlint:disable strict_fileprivate
    fileprivate let update: (Value) -> Void

    fileprivate init(value: Value?, update: @escaping (Value) -> Void) {
      self.value = value
      self.update = update
    }

    // swiftlint:enable strict_fileprivate

    public func get() -> Value? {
      value
    }
  }

  public struct PreferredLayoutView<Content: View, ValueType>: View {
    let reduce: (ValueType, ValueType) -> ValueType
    let content: (Value<ValueType>) -> Content
    @State private var value: ValueType?

    public var body: some View {
      let valueType = Value(value: self.value) { newValue in
        let value = value ?? newValue
        self.value = reduce(value, newValue)
      }
      content(valueType)
    }

    public init(
      initial: ValueType? = nil,
      reduce: @escaping (ValueType, ValueType) -> ValueType,
      content: @escaping (Value<ValueType>) -> Content
    ) {
      self.reduce = reduce
      self.content = content
      self.value = initial
    }
  }

  extension PreferredLayoutView where ValueType: Comparable {
    public init(content: @escaping (Value<ValueType>) -> Content) {
      self.init(reduce: max, content: content)
    }
  }

  extension View {
    public func apply<V>(
      _ keyPath: KeyPath<GeometryProxy, V>,
      with valueType: Value<V>
    ) -> some View {
      self.apply(keyPath, with: valueType) {
        Color.clear
      }
    }

    public func apply<V>(
      _ keyPath: KeyPath<GeometryProxy, V>,
      with valueType: Value<V>,
      backgroundView: @escaping () -> some View
    ) -> some View {
      self
        .background(GeometryReader { geometry in
          backgroundView().onAppear(perform: {
            valueType.update(geometry[keyPath: keyPath])
          })
        })
    }
  }
#endif
