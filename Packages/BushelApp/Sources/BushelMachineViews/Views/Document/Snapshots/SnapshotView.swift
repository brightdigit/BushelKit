//
// SnapshotView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelMachine
  import SwiftUI

  internal struct SnapshotView: View {
    @Environment(\.purchaseWindow) private var purchaseWindow
    @Environment(\.openWindow) private var openWindow
    @Environment(\.marketplace) private var marketplace

    @Bindable var snapshot: SnapshotObject
    let saveAction: (SnapshotObject) -> Void
    let timer = Timer.publish(every: 1.0, on: RunLoop.current, in: RunLoop.Mode.common).autoconnect()

    var body: some View {
      Form {
        nameSection()

        Section {
          HStack {
            Text(.snapshotDetailsPropertyDicardable).font(.subheadline)
            Toggle(
              .snapshotDetailsPropertyDicardable,
              systemImage: "trash.fill",
              isOn: .constant(self.snapshot.isDiscardable)
            )
            .labelStyle(.titleOnly)
            .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
            .allowsHitTesting(/*@START_MENU_TOKEN@*/false/*@END_MENU_TOKEN@*/)
            .labelsHidden()
          }
        }.padding(.top, 2.0)

        if let label = snapshot.label {
          Section {
            Text(label.operatingSystemLongName).font(.headline).fontWeight(.semibold)
          } header: {
            Text(label.systemName).font(.subheadline).padding(.top, 2.0)
          }
        }

        Section {
          Text(self.snapshot.createdAt, formatter: Formatters.snapshotDateFormatter)
            .font(.headline)
            .fontWeight(.semibold)
        } header: {
          Text(.snapshotDetailsPropertyCreated).font(.subheadline).padding(.top, 2.0)
        }

        notesSection()
      }
      .onReceive(self.timer) { _ in
        if self.snapshot.hasChanges {
          self.saveAction(snapshot)
        }
      }
    }

    internal init(
      snapshot: Bindable<SnapshotObject>,
      saveAction: @escaping (SnapshotObject) -> Void
    ) {
      self._snapshot = snapshot
      self.saveAction = saveAction
    }

    private func notesSection() -> some View {
      Section {
        TextEditor(text: self.$snapshot.notes).onSubmit {
          self.saveAction(self.snapshot)
        }
        .disabled(!marketplace.purchased)
        .foregroundStyle(
          self.marketplace.purchased ?
            Color.primary :
            Color.primary.opacity(0.5)
        )
      } header: {
        HStack {
          Text(.snapshotDetailsPropertyNotes).font(.subheadline).padding(.top, 2.0)

          if !marketplace.purchased {
            Spacer()
            Button(action: {
              openWindow(value: purchaseWindow)
            }, label: {
              Text(.upgradePurchase).foregroundStyle(Color.blue)
            }).buttonStyle(.plain)
          }
        }
      }
    }

    private func nameSection() -> some View {
      Section {
        TextField("Name", text: self.$snapshot.name).labelsHidden().disabled(!marketplace.purchased)
      } header: {
        HStack {
          Text(.snapshotDetailsPropertyName)
          if !marketplace.purchased {
            Spacer()
            Button(action: {
              openWindow(value: purchaseWindow)
            }, label: {
              Text(.upgradePurchase).textCase(.uppercase).foregroundStyle(Color.blue)
            }).buttonStyle(.plain)
          }
        }.font(.subheadline)
      }
    }
  }

#endif
