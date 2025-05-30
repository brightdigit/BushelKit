import Testing

@testable import BushelUtilities

@Suite("Array Extension Tests")
internal struct ArrayExtensionTests {
  @Test("Indices expect first")
  internal func testIndiciesExpectFirst() {
    let array1 = [1, 2, 3, 4, 5]
    #expect(Array.indiciesExpectFirst(array1) == [1, 2, 3, 4])

    let array2: [Int] = []
    #expect(Array.indiciesExpectFirst(array2).isEmpty)

    let array3 = [1]
    #expect(Array.indiciesExpectFirst(array3).isEmpty)
  }

  @Test("Removing duplicates")
  internal func testRemovingDuplicates() {
    // Test with simple integers
    let numbers = [1, 2, 2, 3, 3, 4]
    let uniqueNumbers = numbers.removingDuplicates(groupingBy: { $0 })
    #expect(uniqueNumbers == [1, 2, 3, 4])

    // Test with custom grouping
    struct Person {
      let id: Int
      let name: String
    }

    let people = [
      Person(id: 1, name: "John"),
      Person(id: 1, name: "John"),
      Person(id: 2, name: "Jane"),
      Person(id: 2, name: "Jane"),
    ]

    let uniquePeople = people.removingDuplicates(groupingBy: { $0.id })
    #expect(uniquePeople.count == 2)
    #expect(uniquePeople[0].id == 1)
    #expect(uniquePeople[1].id == 2)
  }

  @Test("Remove duplicates")
  internal func testRemoveDuplicates() {
    var numbers = [1, 2, 2, 3, 3, 4]
    numbers.removeDuplicates(groupingBy: { $0 })
    #expect(numbers == [1, 2, 3, 4])

    // Test with custom indiciesToRemove
    var customNumbers = [1, 2, 2, 3, 3, 4]
    customNumbers.removeDuplicates(
      groupingBy: { $0 },
      indiciesToRemove: { elements in
        // Return all indices except the last one to keep the last element
        Array(0..<(elements.count - 1))
      }
    )
    #expect(customNumbers == [1, 2, 3, 4])
  }
}
