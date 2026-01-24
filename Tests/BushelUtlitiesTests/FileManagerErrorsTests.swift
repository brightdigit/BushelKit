//
//  FileManagerErrorsTests.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2025 BrightDigit.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

import Testing
import Foundation
@testable import BushelUtilities

struct FileManagerErrorsTests {
  
  @Test("isFileNotFound returns true for file not found error")
  func testIsFileNotFoundWithCorrectError() {
    let error = NSError(
      domain: NSCocoaErrorDomain,
      code: NSFileNoSuchFileError,
      userInfo: nil
    )
    
    #expect(error.isFileNotFound == true)
    #expect(error.isCorruptFile == false)
    #expect(error.isFileNotFoundOrCorrupt == true)
  }
  
  @Test("isFileNotFound returns false for wrong domain")
  func testIsFileNotFoundWithWrongDomain() {
    let error = NSError(
      domain: NSPOSIXErrorDomain,
      code: NSFileNoSuchFileError,
      userInfo: nil
    )
    
    #expect(error.isFileNotFound == false)
    #expect(error.isFileNotFoundOrCorrupt == false)
  }
  
  @Test("isFileNotFound returns false for wrong error code")
  func testIsFileNotFoundWithWrongCode() {
    let error = NSError(
      domain: NSCocoaErrorDomain,
      code: NSFileReadNoPermissionError,
      userInfo: nil
    )
    
    #expect(error.isFileNotFound == false)
  }
  
  @Test("isCorruptFile returns true for corrupt file error")
  func testIsCorruptFileWithCorrectError() {
    let error = NSError(
      domain: NSCocoaErrorDomain,
      code: NSFileReadCorruptFileError,
      userInfo: nil
    )
    
    #expect(error.isCorruptFile == true)
    #expect(error.isFileNotFound == false)
    #expect(error.isFileNotFoundOrCorrupt == true)
  }
  
  @Test("isCorruptFile returns false for wrong domain")
  func testIsCorruptFileWithWrongDomain() {
    let error = NSError(
      domain: NSPOSIXErrorDomain,
      code: NSFileReadCorruptFileError,
      userInfo: nil
    )
    
    #expect(error.isCorruptFile == false)
    #expect(error.isFileNotFoundOrCorrupt == false)
  }
  
  @Test("isCorruptFile returns false for wrong error code")
  func testIsCorruptFileWithWrongCode() {
    let error = NSError(
      domain: NSCocoaErrorDomain,
      code: NSFileReadNoPermissionError,
      userInfo: nil
    )
    
    #expect(error.isCorruptFile == false)
  }
  
  @Test("isFileNotFoundOrCorrupt returns true for file not found")
  func testIsFileNotFoundOrCorruptWithFileNotFound() {
    let error = NSError(
      domain: NSCocoaErrorDomain,
      code: NSFileNoSuchFileError,
      userInfo: nil
    )
    
    #expect(error.isFileNotFoundOrCorrupt == true)
  }
  
  @Test("isFileNotFoundOrCorrupt returns true for corrupt file")
  func testIsFileNotFoundOrCorruptWithCorruptFile() {
    let error = NSError(
      domain: NSCocoaErrorDomain,
      code: NSFileReadCorruptFileError,
      userInfo: nil
    )
    
    #expect(error.isFileNotFoundOrCorrupt == true)
  }
  
  @Test("isFileNotFoundOrCorrupt returns false for other errors")
  func testIsFileNotFoundOrCorruptWithOtherError() {
    let error = NSError(
      domain: NSCocoaErrorDomain,
      code: NSFileReadNoPermissionError,
      userInfo: nil
    )
    
    #expect(error.isFileNotFoundOrCorrupt == false)
  }
  
  @Test("isFileNotFoundOrCorrupt returns false for different domain")
  func testIsFileNotFoundOrCorruptWithDifferentDomain() {
    let error = NSError(
      domain: NSURLErrorDomain,
      code: NSFileNoSuchFileError,
      userInfo: nil
    )
    
    #expect(error.isFileNotFoundOrCorrupt == false)
  }
  
  @Test("All error properties work with userInfo populated")
  func testErrorPropertiesWithUserInfo() {
    let userInfo: [String: Any] = [
      NSFilePathErrorKey: "/path/to/file",
      NSLocalizedDescriptionKey: "Test error"
    ]
    
    let fileNotFoundError = NSError(
      domain: NSCocoaErrorDomain,
      code: NSFileNoSuchFileError,
      userInfo: userInfo
    )
    
    let corruptFileError = NSError(
      domain: NSCocoaErrorDomain,
      code: NSFileReadCorruptFileError,
      userInfo: userInfo
    )
    
    #expect(fileNotFoundError.isFileNotFound == true)
    #expect(fileNotFoundError.isCorruptFile == false)
    #expect(fileNotFoundError.isFileNotFoundOrCorrupt == true)
    
    #expect(corruptFileError.isFileNotFound == false)
    #expect(corruptFileError.isCorruptFile == true)
    #expect(corruptFileError.isFileNotFoundOrCorrupt == true)
  }
}