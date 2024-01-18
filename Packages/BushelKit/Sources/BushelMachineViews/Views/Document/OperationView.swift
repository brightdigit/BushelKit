//
// OperationView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import SwiftUI

  struct OperationView: View {
    let operation: MachineOperation

    var body: some View {
      ZStack {
        ProgressView {
          HStack {
            Text(operation.stringID)
            if let label = operation.label {
              Text(label)
            }
          }
        }
      }.padding(40)
    }
  }

  #Preview {
    OperationView(
      operation: .exportingSnapshot(
        .init(
          name: "Hello",
          id: .init(),
          snapshotterID: "mock",
          createdAt: .init(),
          isDiscardable: false
        )
      )
    )
  }
#endif
