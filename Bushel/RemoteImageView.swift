//
//  RemoteImageView.swift
//  Bushel
//
//  Created by Leo Dion on 5/27/22.
//

import SwiftUI
struct RemoteImageView: View {
  @EnvironmentObject var object : AppObject
  @StateObject var downloader = Downloader()
  @State var error : Error?
  
  let numberFormatter : NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.maximumFractionDigits = 2
    return formatter
  }()
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
          Text(image?.lastModified.formatted() ?? "")
        }
        VStack{
          Button {
            
              guard let image = image else {
                return
              }
              do {
              try self.object.beginDownloadingRemoteImage(image, with: downloader)
              } catch {
                self.error = error
              }
          } label: {
            Text(downloader.isActive ?
                 "\(self.numberFormatter.string(from: (downloader.percentCompleted ?? 0.0) as NSNumber)!)% Downloaded" :
                 "Download \(image?.size ?? "")").frame(maxWidth: .infinity)
          }.disabled(downloader.isActive)

          
              ProgressView(
                value: Float(self.downloader.totalBytesWritten) ,
                total:  self.downloader.totalBytesExpectedToWrite.map(Float.init) ?? 0.0
              ).opacity(self.downloader.totalBytesExpectedToWrite == nil ? 0.0 : 1.0)
        }.frame(width: 150.0).padding(.horizontal)
      }.padding().frame(height: 120.0, alignment: .center)
    }
}

struct RemoteImageView_Previews: PreviewProvider {
    static var previews: some View {
      RemoteImageView(image: .previewModel)
    }
}
