//
//  RestoreImageDocument.swift
//  BshIll
//
//  Created by Leo Dion on 6/22/22.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers
import Virtualization







struct RestoreImageDocument: FileDocument {
  let fileWrapper : FileWrapper

  
  //let loader : RestoreImageLoader
  
  static let readableContentTypes = UTType.ipswTypes
  
  
  init(configuration: ReadConfiguration) throws {
    self.fileWrapper = configuration.file
  }
  
  
  func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
    guard let fileWrapper = configuration.existingFile else {
      throw NSError()
    }
    
    return fileWrapper
  }
  
  
  
}
