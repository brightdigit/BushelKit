//
// PurchaseHeaderView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelViewsCore
  import SwiftUI

  struct PurchaseHeaderView: View {
    var body: some View {
      PreferredLayoutView { value in
        VStack(spacing: 20) {
          Image.resource("Logo").resizable().aspectRatio(contentMode: .fit).frame(height: 120)

          Text(.welcomeToBushel)
            .font(.system(size: 36.0))
            .fontWeight(.bold)

          Text("""
               Misit et his **condita** fontis precantia Aegaeo. Transire **nymphae sontem**
               dederat tecta aliter addidit necis ab tibi solari tenuere Circes positis
               aequantur permittat urbes loquendo.
          """).multilineTextAlignment(.leading).lineLimit(3, reservesSpace: true).apply(\.size.width, with: value)

          HStack {
            Spacer()
            VStack(alignment: .leading, spacing: 8.0) {
              PurchaseFeatureView(systemName: "circle", title: "Lorem Ipsum", description: "Misit et his **condita** fontis precantia Aegaeo.")
              PurchaseFeatureView(systemName: "circle", title: "Lorem Ipsum", description: "Misit et his **condita** fontis precantia Aegaeo.")
              PurchaseFeatureView(systemName: "circle", title: "Lorem Ipsum", description: "Misit et his **condita** fontis precantia Aegaeo.")
              PurchaseFeatureView(systemName: "circle", title: "Lorem Ipsum", description: "Misit et his **condita** fontis precantia Aegaeo.")
              PurchaseFeatureView(systemName: "circle", title: "Lorem Ipsum", description: "Misit et his **condita** fontis precantia Aegaeo.")
            }.padding(12.0).frame(width: value.get(), alignment: .leading)
            Spacer()
          }
        }
      }.padding(.vertical, 40)
        .padding(.top, 20)
    }
  }

  #Preview {
    PurchaseHeaderView()
  }
#endif
