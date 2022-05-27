//
//  MainView.swift
//  Bushel
//
//  Created by Leo Dion on 5/27/22.
//

import SwiftUI

struct Image : Codable, Identifiable {
  let name : String
  let url : URL
  
  var id: URL {
    url
  }
}
struct Configuration : Codable {
  let images : Image
}
struct MainView: View {

    var body: some View {
      TabView {
        List(
      }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
