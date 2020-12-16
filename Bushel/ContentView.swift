//
//  ContentView.swift
//  Bushel
//
//  Created by Leo Dion on 12/15/20.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: BushelDocument

    var body: some View {
        TextEditor(text: $document.text)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(document: .constant(BushelDocument()))
    }
}
