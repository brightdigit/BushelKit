import Foundation
import CommonCrypto

struct SHA256 : Codable, Hashable {
  internal init(data: Data) {
    self.data = data
  }
  
  internal init?(hexidecialString: String) {
    guard let data = hexidecialString.hexadecimal else {
      return nil
    }
    self.init(data: data)
  }
  
  let data : Data
}

extension String {
    
    /// Create `Data` from hexadecimal string representation
    ///
    /// This creates a `Data` object from hex string. Note, if the string has any spaces or non-hex characters (e.g. starts with '<' and with a '>'), those are ignored and only hex characters are processed.
    ///
    /// - returns: Data represented by this hexadecimal string.
    
    var hexadecimal: Data? {
        var data = Data(capacity: count / 2)
        
        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: self, range: NSRange(startIndex..., in: self)) { match, _, _ in
            let byteString = (self as NSString).substring(with: match!.range)
            let num = UInt8(byteString, radix: 16)!
            data.append(num)
        }
        
        guard data.count > 0 else { return nil }
        
        return data
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
