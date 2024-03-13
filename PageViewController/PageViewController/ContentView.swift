//
//  ContentView.swift
//  PageViewController
//
//  Created by Leo Dion on 3/4/24.
//

import SwiftUI


struct ContentView: View {
    var body: some View {
      PageView(onDismiss: nil) {
        ContainerView{
          RestoreImageSelectorView()
        }
        ContainerView{
          SpecificationConfigurationView()
        }
      }
      
    }
}

#Preview {
    ContentView()
}

struct ContainerView<Content : View>: View {
  @Environment(\.nextPage) var nextPage
  let content : () -> Content
  var body: some View {
    VStack{
      Spacer()
      content().padding()
      Spacer()
      HStack{
        Button {
          
        } label: {
          Text("Cancel").padding(.horizontal)
        }
        Spacer()
        Button {
          
        } label: {
          Text("Previous").padding(.horizontal)
        }
        Button {
          nextPage()
        } label: {
          Text("Next").padding(.horizontal)
        }
      }
    }.padding()
  }
}

struct FirstPageView: View {
  var body: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)
      Text("Hello, world!")
    }
    .padding()
    .frame(width: 500, height: 300)
  }
}
