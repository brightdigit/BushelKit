//
//  WelcomeView.swift
//  BshIll
//
//  Created by Leo Dion on 6/26/22.
//

import SwiftUI
import UniformTypeIdentifiers

struct WelcomeView: View {
    @State var openDocumentIsVisible = false

    var body: some View {
        HStack{
            VStack{
                Image("Logo").resizable().aspectRatio(contentMode: .fit).frame(width: 200)
                Text("Welcome to Bshill").font(.custom("Raleway", size: 42.0)).fontWeight(.medium)
                Text("Version 0.1 alpha (0000001)").font(.custom("Raleway", size: 14.0)).fontWeight(.medium).foregroundColor(.secondary)
                
                VStack(alignment: .leading){
                    WelcomeActionButton(imageSystemName: "plus.app", title: "Create a new Machine", description: "Create a new Virtual Machine for Testing Your App") {
                        BshIllApp.showNewDocumentWindow(ofType: .virtualMachine)
                    }
                    
                    WelcomeActionButton(imageSystemName: "square.and.arrow.down", title: "Open an existing Machine", description: "Open and Run an existing virtual machine.") {
                        self.openDocumentIsVisible = true
                    }.fileImporter(isPresented: self.$openDocumentIsVisible,allowedContentTypes:
                                    [UTType(filenameExtension: "bshvm")!]
                    ) { result in
                        if let url = try? result.get() {
                            BshIllApp.openDocumentAtURL(url)
                        }
                    }
                    //WelcomeActionButton().padding()
                    
                    WelcomeActionButton(imageSystemName: "server.rack", title: "Start an Image Library", description: "Create a library for your Restore Images.") {
                      BshIllApp.showNewDocumentWindow(ofType: .restoreImageLibrary)
                    }
                    
                    
                    WelcomeActionButton(imageSystemName: "square.and.arrow.down.on.square", title: "Download a Restore Image", description: "Download a new version of macOS.") {
                      BshIllApp.openWindow(withHandle: BasicWindowOpenHandle.remoteSources)
                    }
                }
            }
            
        }.padding()
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
