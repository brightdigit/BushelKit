//
//  ContentView.swift
//  BshillDoc
//
//  Created by Leo Dion on 6/18/22.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: BshillDocDocument

    var body: some View {
        TextEditor(text: .constant(""))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(document: .constant(BshillDocDocument()))
    }
}
