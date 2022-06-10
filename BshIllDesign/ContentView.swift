//
//  ContentView.swift
//  BshIllDesign
//
//  Created by Leo Dion on 6/8/22.
//

import SwiftUI

struct Machine : Identifiable {
    internal init( imageName: String) {
        self.id = UUID()
        self.imageName = imageName
        var title = imageName.components(separatedBy: "-")
        title.removeFirst()
        self.title = String(title.map{$0.capitalized}.joined(separator: " "))
    }
    
    let id : UUID
    let imageName : String
    let title : String
}
let machines = ["001-desktop",
"002-computer",
"003-desktop-computer",
"004-computer-1",
"005-desktop-1",
"006-settings",
"007-computer-2",
"008-pc",
"009-imac",
"010-old-computer",
"011-laptop",
"012-mac",
"013-desktop-2",
"014-macbook",
"015-mac-mini",
"016-mac-mini-1",
"017-mac-1",
"018-imac-1",
"019-mac-pro",
"020-computer-3",
"021-monitor",
"022-command",
"042-data-server",
"043-server",
"044-server-1",
"045-data-storage",
"046-server-2",
"047-server-3",
"048-data-center",
"049-server-4",
"050-mac-pro-1",
"051-mac-pro-2",
"052-imac-2",
                "053-computer-4"].shuffled().prefix(10).map(Machine.init(imageName:))



struct ContentView: View {
    
    var body: some View {
        TabView{
            ImageListView().tabItem {
                Text("Images")
            }
            MachineListView().tabItem {
                Text("Machines")
            }
            SettingsView().tabItem {
                Text("Settings")
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
