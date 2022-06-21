//
//  BshillDocDocument.swift
//  BshillDoc
//
//  Created by Leo Dion on 6/18/22.
//

import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static var exampleText: UTType {
        UTType(importedAs: "com.example.plain-text")
    }
}

struct Disk : Identifiable {
    let name = UUID().uuidString
    let id : UUID
}
struct BshillDocDocument: FileDocument {
    let disks = [Disk]()

    static var readableContentTypes: [UTType] { [.exampleText] }

    init () {
        
    }
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = Data()
        return .init(regularFileWithContents: data)
    }
}
