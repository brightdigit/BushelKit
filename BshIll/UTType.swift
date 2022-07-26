import UniformTypeIdentifiers

extension UTType {
    static var virtualMachine: UTType {
        UTType(exportedAs: "com.brightdigit.bshill-vm")
    }
}



extension UTType {
  //[.init("com.apple.itunes.ipsw")!, .init("com.apple.iphone.ipsw")!]
  static let iTunesIPSW : UTType = .init("com.apple.itunes.ipsw")!
  static let iPhoneIPSW : UTType = .init("com.apple.iphone.ipsw")!
  
  static let ipswTypes = [iTunesIPSW, iPhoneIPSW]
}

extension UTType {
  static var restoreImageLibrary: UTType {
    UTType(exportedAs: "com.brightdigit.bshill-rilib")
  }
}
