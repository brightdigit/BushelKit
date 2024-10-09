//
//  MockService.swift
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

import BushelMessageCore
import BushelSessionCore
import Foundation

internal class MockService: SessionService {
  internal enum Error: Swift.Error {
    case wrongMessage
    case wrongResponse
  }

  internal var messagesSent = [any Message]()
  internal var reason: ServiceCancelReason?

  internal func sendMessage<MessageType>(
    _ message: MessageType
  ) async throws -> MessageType.ResponseType where MessageType: Message {
    self.messagesSent.append(message)
    guard let message = message as? MockMessage else {
      throw Error.wrongMessage
    }
    guard let response = message.response as? MessageType.ResponseType else {
      throw Error.wrongResponse
    }
    return response
  }

  internal func cancel(reason: ServiceCancelReason) {
    self.reason = reason
  }
}
