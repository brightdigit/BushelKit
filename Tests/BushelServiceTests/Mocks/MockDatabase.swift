//
//  MockDatabase.swift
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

#if canImport(SwiftData)
    import BushelDataCore
    import Foundation
    import SwiftData

    class MockDatabase: Database {
        var didRequestCount: Int?
        func contextMatchesModel(_: some PersistentModel) async -> Bool {
            false
        }

        func delete(where _: Predicate<some PersistentModel>?) async throws {}

        func fetch<T>(_ descriptor: FetchDescriptor<T>) async throws -> [T] where T: PersistentModel {
            guard let count = descriptor.fetchLimit else {
                return []
            }
            didRequestCount = count
            return (0 ..< count).map { _ in
                ItemModel()
            }
            .compactMap { $0 as? T }
        }

        func delete(_: some PersistentModel) async {}

        func insert(_: some PersistentModel) async {}

        func save() async throws {}

        func transaction(_: @escaping (ModelContext) throws -> Void) async throws {}
    }
#endif
