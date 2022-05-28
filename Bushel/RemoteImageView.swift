//
//  RemoteImageView.swift
//  Bushel
//
//  Created by Leo Dion on 5/27/22.
//

import SwiftUI


struct RemoteImageView: View {
  let image : RemoteImage
    var body: some View {
      HStack{
        Image(systemName: "applelogo")
      
//        Form{
//          Section{
//          TextField("Build Version", text: .constant(image.buildVersion))
//          Text(image.buildVersion)
//          Text("macOS \(image.operatingSystemVersion.description)")
//          Text(image.url.absoluteString)
//          }
//        }
      }
    }
}

struct RemoteImageView_Previews: PreviewProvider {
    static var previews: some View {
      RemoteImageView(image: .init(buildVersion: "21F79", operatingSystemVersion: .init(majorVersion: 12, minorVersion: 4, patchVersion: 0), url: .init(string: "https://apple.com")!))
    }
}
