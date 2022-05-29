//
//  BushelApp.swift
//  Bushel
//
//  Created by Leo Dion on 5/25/22.
//

import SwiftUI
import Virtualization

@main
struct BushelApp: App {
    var body: some Scene {
        WindowGroup {
          MainView().environmentObject(AppObject(remoteImageFetcher: nil))
        }
    }
}
