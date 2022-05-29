//
//  ImageList.swift
//  Bushel
//
//  Created by Leo Dion on 5/29/22.
//

import SwiftUI

struct ImageList: View {
  let images : [LocalImage]
  @Binding var imageBinding : LocalImage?
    var body: some View {

      List(images, selection: self.$imageBinding) { image in
        
        HStack{
          ZStack{
            Rectangle().strokeBorder(.secondary).opacity(0.50)
            Rectangle().fill(Color.secondary.opacity(0.25))
            Image(systemName: "applelogo").resizable().aspectRatio(contentMode: .fit).padding(8.0)
          }.aspectRatio(1.0, contentMode: .fit).padding(8.0)
                    VStack(alignment: .leading){
                      Text(image.name).font(.largeTitle)
                      Text(image.operatingSystemVersion.description)
                      Text(image.buildVersion)
                      Text(image.url.absoluteString)
          
                      
//                        Text(image.buildVersion).font(.title)
//
//                      Text(image.url.absoluteString).font(.caption).textSelection(.enabled)
                    }
        }.padding().frame(height: 120.0, alignment: .center)

        }
      
    }
}

struct ImageList_Previews: PreviewProvider {
    static var previews: some View {
      ImageList(images: [.init(name: "Hello", url: .init(string: "https://apple.com")!, buildVersion: "21F79", operatingSystemVersion: .init(majorVersion: 12, minorVersion: 4, patchVersion: 0))], imageBinding: .constant(nil))
    }
}
