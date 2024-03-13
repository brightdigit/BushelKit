//
//  RestoreImageSelectorView.swift
//  PageViewController
//
//  Created by Leo Dion on 3/5/24.
//

import SwiftUI

struct OSData : Identifiable {
  internal init(_ pair: (Int, String)) {
    self.init(id: pair.0, name: pair.1)
  }
  internal init(id: Int, name: String) {
    self.id = id
    self.name = name
  }
  
  let id: Int
  let name : String
  
  var imageName : String {
    "OSVersions/\(name)"
  }
}
struct RestoreImageSelectorView: View {
  private static let oses = [
    //11: "Big Sur",
    12: "Monterey",
    13: "Ventura",
    14: "Sonoma"
  ].map(OSData.init).sorted {
    $0.id < $1.id
  }
  @State var build : BuildVersion?
  @State var osVersion : OSData?
    var body: some View {
      Form {
        Section{
          VStack{
            LabeledContent("macOS") {
              
              HStack{
                ForEach(RestoreImageSelectorView.oses) { codeName in
 

                  Button {
                    self.osVersion = codeName
                  } label: {
                    
                    VStack{
                      Image(codeName.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.vertical, 4.0)
                        .mask { Circle() }
                        .overlay { Circle().stroke() }
                        .frame(width: 50.0)
                      Text("macOS \(codeName.id)").font(.caption)
                      Text(codeName.name)
                    }.padding()
                      .opacity(self.osVersion?.id == codeName.id ? 1.0 : 0.7)
                  }.buttonStyle(.plain)
                }
                Spacer()
                //"paperclip.badge.ellipsis"
                Button{
                  
                } label: {
                  
                  VStack{
                    Image(systemName: "paperclip.badge.ellipsis")
                      .resizable()
                      .aspectRatio(contentMode: .fit)
                      .padding(.vertical, 4.0)
                      .frame(width: 50.0)
                    //Text("macOS \(codeName.id)").font(.caption)
                    Text("Custom")
                  }.opacity(0.9)
                }.buttonStyle(.plain)
              }
            }
            Picker("Build", selection: self.$build) {
              ForEach(BuildVersion.montereyVersions) { version in
                HStack{
                  Text("\(version.semver) (\(version.build))")
                }
              }
            }
            .disabled(self.osVersion == nil)
          }
        }
      }
    }
}

#Preview {
    RestoreImageSelectorView()
}
