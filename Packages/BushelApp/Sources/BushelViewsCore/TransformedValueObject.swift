//
// TransformedValueObject.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  public import Foundation

  public import SwiftUI

  @Observable
  public class TransformedValueObject<InputValue, OutputValue, FormattableValue> {
    private let defaultTransform: (InputValue) -> OutputValue
    private let formattable: (OutputValue) -> FormattableValue

    @ObservationIgnored
    private var transform: ((InputValue) -> OutputValue)?

    @ObservationIgnored
    private var bindingValue: Binding<InputValue?>?

    public var inputValue: InputValue {
      didSet {
        assert(self.transform != nil)
        self.bindingValue?.wrappedValue = inputValue
        self.outputValue = (self.transform ?? self.defaultTransform)(inputValue)
      }
    }

    public private(set) var outputValue: OutputValue {
      didSet {
        self.formattedValue = self.formattable(outputValue)
      }
    }

    public private(set) var formattedValue: FormattableValue

    public init(
      defaultTransform: @escaping (InputValue) -> OutputValue,
      formattable: @escaping (OutputValue) -> FormattableValue,
      inputValue: InputValue,
      outputValue: OutputValue? = nil,
      fomrattedValue: FormattableValue? = nil,
      polynomial: ((InputValue) -> OutputValue)? = nil
    ) {
      self.formattable = formattable
      self.defaultTransform = defaultTransform
      self.transform = polynomial
      self.inputValue = inputValue
      let outputValue = outputValue ?? transform?(inputValue) ?? defaultTransform(inputValue)
      self.outputValue = outputValue
      self.formattedValue = fomrattedValue ?? self.formattable(outputValue)
    }

    public func bindTo(
      _ bindingValue: Binding<InputValue?>,
      using transform: @escaping (InputValue) -> OutputValue
    ) {
      assert(self.bindingValue == nil)
      assert(self.transform == nil)
      self.transform = transform
      self.inputValue = bindingValue.wrappedValue ?? self.inputValue
      self.bindingValue = bindingValue
    }
  }
#endif
