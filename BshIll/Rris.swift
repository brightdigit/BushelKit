import Virtualization


struct Rris : Identifiable, Hashable {
    static func == (lhs: Rris, rhs: Rris) -> Bool {
        lhs.id == rhs.id
    }
    
    let id : String
    let title : String
    let fetch : () async throws -> [RestoreImage]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}


extension Rris {
    static let apple : Rris = .init(id: "apple", title: "Apple") {
      let vzRestoreImage = try await VZMacOSRestoreImage.fetchLatestSupported()
      let virRestoreImage = try await VirtualizationMacOSRestoreImage(vzRestoreImage: vzRestoreImage, sha256: nil)
      return [RestoreImage(imageContainer: virRestoreImage)]
//        try await withCheckedThrowingContinuation { continuation in
//            VZMacOSRestoreImage.fetchLatestSupported { result in
//              result.map(Virt)
//                continuation.resume(with: result.map(RestoreImage.init(imageMetadata:)).map{[$0]})
//
//            }
//        }
    }
}
