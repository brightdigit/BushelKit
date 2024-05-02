//
// ContainerView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import SwiftUI

  public struct ContainerView<Label: View, Content: View>: View {
    @Environment(\.pageNavigationAvailability) var pageNavigationAvailability
    @Environment(\.previousPage) var previousPage
    @Environment(\.nextPage) var nextPage
    @Environment(\.cancelPage) var cancel
    let content: (Binding<Bool>) -> Content
    let label: () -> Label
    @State var isNextReady: Bool = false
    var isPreviousDisabled: Bool {
      !pageNavigationAvailability.contains(.previous)
    }

    var isNextDisabled: Bool {
      !isNextReady
    }

    public var body: some View {
      VStack {
        HStack {
          label()
          Spacer()
        }
        Spacer()
        HStack {
          Spacer()
          VStack {
            Spacer()
            content($isNextReady).padding()
            Spacer()
          }
          Spacer()
        }
        .border(Color.primary.opacity(0.2))
        Spacer().frame(height: 16)
        HStack {
          Button {
            cancel()
          } label: {
            Text("Cancel").padding(.horizontal)
          }
          Spacer()
          Button {
            previousPage()
          } label: {
            Text("Previous").padding(.horizontal)
          }.disabled(isPreviousDisabled).opacity(isPreviousDisabled ? 0.8 : 1.0)
          Button {
            nextPage()
          } label: {
            Text("Next").padding(.horizontal)
          }.disabled(isNextDisabled).opacity(isNextDisabled ? 0.8 : 1.0)
        }
      }
      .padding()
    }

    public init(
      label: @escaping () -> Label,
      content: @escaping (Binding<Bool>) -> Content
    ) {
      self.label = label
      self.content = content
    }
  }

  #Preview {
    ContainerView(label: {
      Text("Hello World")
    }, content: { _ in
      Form {
        Section {
          Text("Hello World")
        }
      }
    })
  }
#endif
