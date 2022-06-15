//
//  ImageListView.swift
//  BshIllDesign
//
//  Created by Leo Dion on 6/9/22.
//

import SwiftUI

struct ImageListView: View {
    var body: some View {
        VStack{
            HStack{
                Button("New") {
                    
                }
            }
            LazyVGrid(columns: [GridItem(.fixed(120)),GridItem(.fixed(120)),GridItem(.fixed(120))], content: {
                
                ForEach(machines) { machine in
                    VStack{
                        Image(machine.imageName).resizable().aspectRatio(contentMode: .fit).padding(.horizontal, 20.0)
                        Text(machine.title).lineLimit(1).padding(4.0)
                    }.padding()
                }
            })
        }
    }
}

struct ImageListView_Previews: PreviewProvider {
    static var previews: some View {
        ImageListView()
    }
}
