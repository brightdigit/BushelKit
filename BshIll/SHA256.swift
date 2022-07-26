import Foundation
import CommonCrypto

struct SHA256 : Codable, Hashable, CustomDebugStringConvertible {
  internal init(digest: Data) {
    self.data = digest
  }
  
  internal init(hashFromCompleteData data: Data) {
    let hash = CryptoSHA256.hash(data: data)
    let digest = Data(hash)
    self.init(digest: digest)
  }
  
  internal init?(hexidecialString: String) {
    guard let data = hexidecialString.hexadecimal else {
      return nil
    }
    self.init(digest: data)
  }
  
  internal init(fileURL: URL) async throws {
    let task = Task {
      var hasher = CryptoSHA256()
      let handle = try FileHandle(forReadingFrom: fileURL)
      
      while try autoreleasepool(invoking: {
        let data = try handle.read(upToCount: CryptoSHA256.blockByteCount)
        guard let data = data, !data.isEmpty else {
          
          return false
        }
        hasher.update(data: data)
        return true
      }) {}
      
      let hash = hasher.finalize()
      return Data(hash)
    }
    
    try   await self.init(digest: task.value)
   
  }
  
  let data : Data
  
  var debugDescription: String {
    return "SHA256(base64Encoded: \"\(self.data.base64EncodedString())\")!"
  }
}

extension SHA256 {
  internal init?(base64Encoded: String) {
    guard let data = Data(base64Encoded: base64Encoded) else {
      return nil
    }
    self.init(digest: data)
  }
}

func sha256(url: URL) throws -> Data {
    
        let bufferSize = 1024 * 1024
        // Open file for reading:
        let file = try FileHandle(forReadingFrom: url)
        defer {
            file.closeFile()
        }

        // Create and initialize SHA256 context:
        var context = CC_SHA256_CTX()
        CC_SHA256_Init(&context)

        // Read up to `bufferSize` bytes, until EOF is reached, and update SHA256 context:
        while autoreleasepool(invoking: {
            // Read up to `bufferSize` bytes
            let data = file.readData(ofLength: bufferSize)
            if data.count > 0 {
              _ = data.withUnsafeBytes { bytesFromBuffer -> Int32 in
                guard let rawBytes = bytesFromBuffer.bindMemory(to: UInt8.self).baseAddress else {
                  return Int32(kCCMemoryFailure)
                }

                return CC_SHA256_Update(&context, rawBytes, numericCast(data.count))
              }
                // Continue
                return true
            } else {
                // End of file
                return false
            }
        }) { }

        // Compute the SHA256 digest:
      var digestData = Data(count: Int(CC_SHA256_DIGEST_LENGTH))
      _ = digestData.withUnsafeMutableBytes { bytesFromDigest -> Int32 in
        guard let rawBytes = bytesFromDigest.bindMemory(to: UInt8.self).baseAddress else {
          return Int32(kCCMemoryFailure)
        }

        return CC_SHA256_Final(rawBytes, &context)
      }

        return digestData
    
}
