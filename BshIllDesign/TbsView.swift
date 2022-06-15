//
//  ContentView.swift
//  BshIllDesign
//
//  Created by Leo Dion on 6/8/22.
//

import SwiftUI

struct TbsView: View {
    
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

struct TbsView_Previews: PreviewProvider {
    static var previews: some View {
        TbsView()
    }
}
