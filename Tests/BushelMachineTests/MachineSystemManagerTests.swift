//
//  MachineSystemManagerTests.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2024 BrightDigit.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the “Software”), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

import BushelMachineWax
import XCTest

@testable import BushelMachine

final class MachineSystemManagerTests: XCTestCase {
  func testResolveById() {
    let stubOS1: MachineSystemStub = .stubOS1
    let stubOS2: MachineSystemStub = .stubOS2
    let stubOS3: MachineSystemStub = .stubOS3

    let sut = MachineSystemManager([stubOS1, stubOS2, stubOS3])

    let stubOS1Impl = sut.resolve(stubOS1.id) as? MachineSystemStub
    let stubOS2Impl = sut.resolve(stubOS2.id) as? MachineSystemStub

    XCTAssertEqual(stubOS1Impl, stubOS1)
    XCTAssertEqual(stubOS2Impl, stubOS2)
  }
}
