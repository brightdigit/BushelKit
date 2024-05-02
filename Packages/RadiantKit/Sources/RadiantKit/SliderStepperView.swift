//
// SliderStepperView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import SwiftUI

  @MainActor
  public struct SliderStepperView<Content: View, Label: View, TitleType>: View {
    let title: TitleType
    let label: @Sendable (TitleType) -> Label
    @Binding var value: Float
    let bounds: ClosedRange<Float>
    let step: Float
    let content: @Sendable (TitleType) -> Content

    public var body: some View {
      LabeledContent {
        HStack {
          Slider(
            value: $value,
            in: bounds,
            step: step
          )
          self.content(self.title)
            .labelsHidden()
            .frame(width: 50)
            .padding(.horizontal, 6.0)

          Stepper(
            value: $value,
            in: bounds,
            step: 1.0,
            label: {
              self.label(self.title)
            }
          )
          .labelsHidden()
        }
      } label: {
        self.label(self.title)
      }
    }

    public init(
      title: TitleType,
      label: @escaping @Sendable (TitleType) -> Label,
      value: Binding<Float>,
      bounds: ClosedRange<Float>,
      step: Float,
      content: @escaping @Sendable (TitleType) -> Content
    ) {
      self.title = title
      self.label = label
      self._value = value
      self.bounds = bounds
      self.step = step
      self.content = content
    }
  }

#endif
