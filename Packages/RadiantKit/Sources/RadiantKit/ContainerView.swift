//
//  ContainerView.swift
//  RadiantKit
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

#if canImport(SwiftUI)
  import SwiftUI

  public struct ContainerView<Label: View, Content: View>: View {
    @Environment(\.pageNavigationAvailability) private var pageNavigationAvailability
    @Environment(\.previousPage) private var previousPage
    @Environment(\.nextPage) private var nextPage
    @Environment(\.cancelPage) private var cancel
    private let content: (Binding<Bool>) -> Content
    private let label: () -> Label
    @State private var isNextReady = false

    private var isPreviousDisabled: Bool {
      !pageNavigationAvailability.contains(.previous)
    }

    private var isNextDisabled: Bool {
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
