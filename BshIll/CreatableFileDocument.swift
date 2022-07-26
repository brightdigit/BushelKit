import SwiftUI
import UniformTypeIdentifiers


protocol CreatableFileDocument : FileDocument{
  static var untitledDocumentType : UTType { get }
}
