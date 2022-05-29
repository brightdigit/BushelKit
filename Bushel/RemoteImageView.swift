//
//  RemoteImageView.swift
//  Bushel
//
//  Created by Leo Dion on 5/27/22.
//

import SwiftUI
struct RemoteImageView: View {
  @EnvironmentObject var object : AppObject
  let image : RemoteImage?
    var body: some View {
      HStack(spacing: 8.0){
        ZStack{
          Rectangle().strokeBorder(.secondary).opacity(0.50)
          Rectangle().fill(Color.secondary.opacity(0.25))
          Image(systemName: "applelogo").resizable().aspectRatio(contentMode: .fit).padding(8.0)
        }.aspectRatio(1.0, contentMode: .fit)
        VStack(alignment: .leading){
          
          Text("macOS \(image?.operatingSystemVersion.description ?? "")").font(.largeTitle)
          
          Text(image?.buildVersion ?? "").font(.title)
        
          Text(image?.url.absoluteString ?? "").font(.caption).textSelection(.enabled)
        }
        VStack{
          Button("Download") {
            guard let image = image else {
              return
            }
            object.beginDownloadingRemoteImage(image)
          }
        }
      }.padding().frame(height: 120.0, alignment: .center)
    }
}

struct RemoteImageView_Previews: PreviewProvider {
    static var previews: some View {
      RemoteImageView(image: .init(buildVersion: "21F79", operatingSystemVersion: .init(majorVersion: 12, minorVersion: 4, patchVersion: 0), url: .init(string: "https://apple.com")!))
    }
}
