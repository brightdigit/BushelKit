//
//  BushelApp.swift
//  Bushel
//
//  Created by Leo Dion on 12/15/20.
//

import SwiftUI

@main
struct BushelApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: BushelDocument()) { file in
            ContentView(document: file.$document)
        }
    }
}
