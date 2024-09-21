//
//  UInt128.swift
//  Sublimation
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

/// An `ErrorType` for `UInt128` data types. It includes cases
/// for errors that can occur during string
/// conversion.
public enum UInt128Errors: Error {
  /// Input cannot be converted to a UInt128 value.
  case invalidString
}

// MARK: - Data Type

/// A 128-bit unsigned integer value type.
/// Storage is based upon a tuple of 2, 64-bit, unsigned integers.
public struct UInt128 {
  // MARK: Instance Properties

  /// Internal value is presented as a tuple of 2 64-bit
  /// unsigned integers.
  public private(set) var value: (upperBits: UInt64, lowerBits: UInt64)

  /// Counts up the significant bits in stored data.
  public var significantBits: UInt128 { UInt128(UInt128.bitWidth - leadingZeroBitCount) }

  /// Undocumented private variable required for passing this type
  /// to a BinaryFloatingPoint type. See FloatingPoint.swift.gyb in
  /// the Swift stdlib/public/core directory.
  var signBitIndex: Int { 127 - leadingZeroBitCount }

  // MARK: Initializers

  /// Designated initializer for the UInt128 type.
  public init(upperBits: UInt64, lowerBits: UInt64) {
    value.upperBits = upperBits
    value.lowerBits = lowerBits
  }

  public init() { self.init(upperBits: 0, lowerBits: 0) }

  /// Initialize a UInt128 value from a string.
  /// Returns `nil` if input cannot be converted to a UInt128 value.
  ///
  /// - parameter source: the string that will be converted into a
  ///   UInt128 value. Defaults to being analyzed as a base10 number,
  ///   but can be prefixed with `0b` for base2, `0o` for base8
  ///   or `0x` for base16.
  public init?(_ source: String) {
    guard let result = UInt128._valueFromString(source) else { return nil }
    self = result
  }
}

// MARK: - FixedWidthInteger Conformance

// swiftlint:disable all

extension UInt128: FixedWidthInteger {
  // MARK: Instance Properties

  public var nonzeroBitCount: Int {
    value.lowerBits.nonzeroBitCount + value.upperBits.nonzeroBitCount
  }

  public var leadingZeroBitCount: Int {
    if value.upperBits == 0 { return UInt64.bitWidth + value.lowerBits.leadingZeroBitCount }
    return value.upperBits.leadingZeroBitCount
  }

  /// Returns the big-endian representation of the integer, changing the byte order if necessary.
  public var bigEndian: UInt128 {
    #if arch(i386) || arch(x86_64) || arch(arm) || arch(arm64)
      return byteSwapped
    #else
      return self
    #endif
  }

  /// Returns the little-endian representation of the integer, changing the byte order if necessary.
  public var littleEndian: UInt128 {
    #if arch(i386) || arch(x86_64) || arch(arm) || arch(arm64)
      return self
    #else
      return byteSwapped
    #endif
  }

  /// Returns the current integer with the byte order swapped.
  public var byteSwapped: UInt128 {
    UInt128(upperBits: value.lowerBits.byteSwapped, lowerBits: value.upperBits.byteSwapped)
  }

  // MARK: Initializers

  /// Creates a UInt128 from a given value, with the input's value
  /// truncated to a size no larger than what UInt128 can handle.
  /// Since the input is constrained to an UInt, no truncation needs
  /// to occur, as a UInt is currently 64 bits at the maximum.
  public init(_truncatingBits bits: UInt) { self.init(upperBits: 0, lowerBits: UInt64(bits)) }

  /// Creates an integer from its big-endian representation, changing the
  /// byte order if necessary.
  public init(bigEndian value: UInt128) { self = value.bigEndian }

  /// Creates an integer from its little-endian representation, changing the
  /// byte order if necessary.
  public init(littleEndian value: UInt128) { self = value.littleEndian }

  // MARK: Instance Methods

  public func addingReportingOverflow(_ rhs: UInt128) -> (partialValue: UInt128, overflow: Bool) {
    var resultOverflow = false
    let (lowerBits, lowerOverflow) = value.lowerBits.addingReportingOverflow(rhs.value.lowerBits)
    var (upperBits, upperOverflow) = value.upperBits.addingReportingOverflow(rhs.value.upperBits)

    // If the lower bits overflowed, we need to add 1 to upper bits.
    if lowerOverflow { (upperBits, resultOverflow) = upperBits.addingReportingOverflow(1) }

    return (
      partialValue: UInt128(upperBits: upperBits, lowerBits: lowerBits),
      overflow: upperOverflow || resultOverflow
    )
  }

  public func subtractingReportingOverflow(_ rhs: UInt128) -> (
    partialValue: UInt128, overflow: Bool
  ) {
    var resultOverflow = false
    let (lowerBits, lowerOverflow) = value.lowerBits.subtractingReportingOverflow(
      rhs.value.lowerBits
    )
    var (upperBits, upperOverflow) = value.upperBits.subtractingReportingOverflow(
      rhs.value.upperBits
    )

    // If the lower bits overflowed, we need to subtract (borrow) 1 from the upper bits.
    if lowerOverflow { (upperBits, resultOverflow) = upperBits.subtractingReportingOverflow(1) }

    return (
      partialValue: UInt128(upperBits: upperBits, lowerBits: lowerBits),
      overflow: upperOverflow || resultOverflow
    )
  }

  public func multipliedReportingOverflow(by rhs: UInt128) -> (
    partialValue: UInt128, overflow: Bool
  ) {
    let multiplicationResult = multipliedFullWidth(by: rhs)
    let overflowEncountered = multiplicationResult.high > 0

    return (partialValue: multiplicationResult.low, overflow: overflowEncountered)
  }

  public func multipliedFullWidth(by other: UInt128) -> (high: UInt128, low: UInt128.Magnitude) {
    // Bit mask that facilitates masking the lower 32 bits of a 64 bit UInt.
    let lower32 = UInt64(UInt32.max)

    // Decompose lhs into an array of 4, 32 significant bit UInt64s.
    let lhsArray = [
      value.upperBits >> 32, /* 0 */ value.upperBits & lower32, /* 1 */
      value.lowerBits >> 32, /* 2 */ value.lowerBits & lower32 /* 3 */,
    ]

    // Decompose rhs into an array of 4, 32 significant bit UInt64s.
    let rhsArray = [
      other.value.upperBits >> 32, /* 0 */ other.value.upperBits & lower32, /* 1 */
      other.value.lowerBits >> 32, /* 2 */ other.value.lowerBits & lower32 /* 3 */,
    ]

    // The future contents of this array will be used to store segment
    // multiplication results.
    var resultArray = [[UInt64]](repeating: [UInt64](repeating: 0, count: 4), count: 4)

    // Loop through every combination of lhsArray[x] * rhsArray[y]
    for rhsSegment in 0..<rhsArray.count {
      for lhsSegment in 0..<lhsArray.count {
        let currentValue = lhsArray[lhsSegment] * rhsArray[rhsSegment]
        resultArray[lhsSegment][rhsSegment] = currentValue
      }
    }

    // Perform multiplication similar to pen and paper in 64bit, 32bit masked increments.
    let bitSegment8 = resultArray[3][3] & lower32
    let bitSegment7 = UInt128._variadicAdditionWithOverflowCount(
      resultArray[2][3] & lower32,
      resultArray[3][2] & lower32,
      resultArray[3][3] >> 32
    )  // overflow from bitSegment8
    let bitSegment6 = UInt128._variadicAdditionWithOverflowCount(
      resultArray[1][3] & lower32,
      resultArray[2][2] & lower32,
      resultArray[3][1] & lower32,
      resultArray[2][3] >> 32,  // overflow from bitSegment7
      resultArray[3][2] >> 32,  // overflow from bitSegment7
      bitSegment7.overflowCount
    )
    let bitSegment5 = UInt128._variadicAdditionWithOverflowCount(
      resultArray[0][3] & lower32,
      resultArray[1][2] & lower32,
      resultArray[2][1] & lower32,
      resultArray[3][0] & lower32,
      resultArray[1][3] >> 32,  // overflow from bitSegment6
      resultArray[2][2] >> 32,  // overflow from bitSegment6
      resultArray[3][1] >> 32,  // overflow from bitSegment6
      bitSegment6.overflowCount
    )
    let bitSegment4 = UInt128._variadicAdditionWithOverflowCount(
      resultArray[0][2] & lower32,
      resultArray[1][1] & lower32,
      resultArray[2][0] & lower32,
      resultArray[0][3] >> 32,  // overflow from bitSegment5
      resultArray[1][2] >> 32,  // overflow from bitSegment5
      resultArray[2][1] >> 32,  // overflow from bitSegment5
      resultArray[3][0] >> 32,  // overflow from bitSegment5
      bitSegment5.overflowCount
    )
    let bitSegment3 = UInt128._variadicAdditionWithOverflowCount(
      resultArray[0][1] & lower32,
      resultArray[1][0] & lower32,
      resultArray[0][2] >> 32,  // overflow from bitSegment4
      resultArray[1][1] >> 32,  // overflow from bitSegment4
      resultArray[2][0] >> 32,  // overflow from bitSegment4
      bitSegment4.overflowCount
    )
    let bitSegment1 = UInt128._variadicAdditionWithOverflowCount(
      resultArray[0][0],
      resultArray[0][1] >> 32,  // overflow from bitSegment3
      resultArray[1][0] >> 32,  // overflow from bitSegment3
      bitSegment3.overflowCount
    )

    // Shift and merge the results into 64 bit groups, adding in overflows as we go.
    let lowerLowerBits = UInt128._variadicAdditionWithOverflowCount(
      bitSegment8,
      bitSegment7.truncatedValue << 32
    )
    let upperLowerBits = UInt128._variadicAdditionWithOverflowCount(
      bitSegment7.truncatedValue >> 32,
      bitSegment6.truncatedValue,
      bitSegment5.truncatedValue << 32,
      lowerLowerBits.overflowCount
    )
    let lowerUpperBits = UInt128._variadicAdditionWithOverflowCount(
      bitSegment5.truncatedValue >> 32,
      bitSegment4.truncatedValue,
      bitSegment3.truncatedValue << 32,
      upperLowerBits.overflowCount
    )
    let upperUpperBits = UInt128._variadicAdditionWithOverflowCount(
      bitSegment3.truncatedValue >> 32,
      bitSegment1.truncatedValue,
      lowerUpperBits.overflowCount
    )

    // Bring the 64bit unsigned integer results together into a high and low 128bit unsigned integer result.
    return (
      high: UInt128(
        upperBits: upperUpperBits.truncatedValue,
        lowerBits: lowerUpperBits.truncatedValue
      ),
      low: UInt128(
        upperBits: upperLowerBits.truncatedValue,
        lowerBits: lowerLowerBits.truncatedValue
      )
    )
  }

  /// Takes a variable amount of 64bit Unsigned Integers and adds them together,
  /// tracking the total amount of overflows that occurred during addition.
  ///
  /// - Parameter addends:
  ///      Variably sized list of UInt64 values.
  /// - Returns:
  ///      A tuple containing the truncated result and a count of the total
  ///      amount of overflows that occurred during addition.
  private static func _variadicAdditionWithOverflowCount(_ addends: UInt64...) -> (
    truncatedValue: UInt64, overflowCount: UInt64
  ) {
    var sum: UInt64 = 0
    var overflowCount: UInt64 = 0

    for addend in addends {
      let interimSum = sum.addingReportingOverflow(addend)
      if interimSum.overflow { overflowCount += 1 }
      sum = interimSum.partialValue
    }

    return (truncatedValue: sum, overflowCount: overflowCount)
  }

  public func dividedReportingOverflow(by rhs: UInt128) -> (partialValue: UInt128, overflow: Bool) {
    guard rhs != 0 else { return (self, true) }

    let quotient = quotientAndRemainder(dividingBy: rhs).quotient
    return (quotient, false)
  }

  public func dividingFullWidth(_ dividend: (high: UInt128, low: UInt128)) -> (
    quotient: UInt128, remainder: UInt128
  ) { _quotientAndRemainderFullWidth(dividingBy: dividend) }

  public func remainderReportingOverflow(dividingBy rhs: UInt128) -> (
    partialValue: UInt128, overflow: Bool
  ) {
    guard rhs != 0 else { return (self, true) }

    let remainder = quotientAndRemainder(dividingBy: rhs).remainder
    return (remainder, false)
  }

  public func quotientAndRemainder(dividingBy rhs: UInt128) -> (
    quotient: UInt128, remainder: UInt128
  ) { rhs._quotientAndRemainderFullWidth(dividingBy: (high: 0, low: self)) }

  /// Provides the quotient and remainder when dividing the provided value by self.
  func _quotientAndRemainderFullWidth(dividingBy dividend: (high: UInt128, low: UInt128)) -> (
    quotient: UInt128, remainder: UInt128
  ) {
    let divisor = self
    let numeratorBitsToWalk: UInt128

    if dividend.high > 0 {
      numeratorBitsToWalk = dividend.high.significantBits + 128 - 1
    }
    else if dividend.low == 0 {
      return (0, 0)
    }
    else {
      numeratorBitsToWalk = dividend.low.significantBits - 1
    }

    // The below algorithm was adapted from:
    // https://en.wikipedia.org/wiki/Division_algorithm#Integer_division_.28unsigned.29_with_remainder

    precondition(self != 0, "Division by 0")

    var quotient = UInt128.min
    var remainder = UInt128.min

    for numeratorShiftWidth in (0...numeratorBitsToWalk).reversed() {
      remainder <<= 1
      remainder |= UInt128._bitFromDoubleWidth(at: numeratorShiftWidth, for: dividend)

      if remainder >= divisor {
        remainder -= divisor
        quotient |= 1 << numeratorShiftWidth
      }
    }

    return (quotient, remainder)
  }

  /// Returns the bit stored at the given position for the provided double width UInt128 input.
  ///
  /// - parameter at: position to grab bit value from.
  /// - parameter for: the double width UInt128 data value to grab the
  ///   bit from.
  /// - returns: single bit stored in a UInt128 value.
  static func _bitFromDoubleWidth(at bitPosition: UInt128, for input: (high: UInt128, low: UInt128))
    -> UInt128
  {
    switch bitPosition { case 0: input.low & 1

      case 1...127: input.low >> bitPosition & 1

      case 128: input.high & 1

      default: input.high >> (bitPosition - 128) & 1
    }
  }
}

// MARK: - BinaryInteger Conformance

extension UInt128 {
  // MARK: Instance Properties

  public static var bitWidth: Int { 128 }
}

extension UInt128: BinaryInteger {
  // MARK: Instance Methods

  public var words: [UInt] { Array(value.lowerBits.words) + Array(value.upperBits.words) }

  public var trailingZeroBitCount: Int {
    if value.lowerBits == 0 { return UInt64.bitWidth + value.upperBits.trailingZeroBitCount }
    return value.lowerBits.trailingZeroBitCount
  }

  // MARK: Initializers

  public init?(exactly source: some BinaryFloatingPoint) {
    if source.isZero {
      self = UInt128()
    }
    else if source.exponent < 0 || source.rounded() != source {
      return nil
    }
    else {
      self = UInt128(UInt64(source))
    }
  }

  public init(_ source: some BinaryFloatingPoint) { self.init(UInt64(source)) }

  // MARK: Type Methods

  public static func / (lhs: UInt128, rhs: UInt128) -> UInt128 {
    let result = lhs.dividedReportingOverflow(by: rhs)

    return result.partialValue
  }

  public static func /= (lhs: inout UInt128, rhs: UInt128) { lhs = lhs / rhs }

  public static func % (lhs: UInt128, rhs: UInt128) -> UInt128 {
    let result = lhs.remainderReportingOverflow(dividingBy: rhs)

    return result.partialValue
  }

  public static func %= (lhs: inout UInt128, rhs: UInt128) { lhs = lhs % rhs }

  /// Performs a bitwise AND operation on 2 UInt128 data types.
  public static func &= (lhs: inout UInt128, rhs: UInt128) {
    let upperBits = lhs.value.upperBits & rhs.value.upperBits
    let lowerBits = lhs.value.lowerBits & rhs.value.lowerBits

    lhs = UInt128(upperBits: upperBits, lowerBits: lowerBits)
  }

  /// Performs a bitwise OR operation on 2 UInt128 data types.
  public static func |= (lhs: inout UInt128, rhs: UInt128) {
    let upperBits = lhs.value.upperBits | rhs.value.upperBits
    let lowerBits = lhs.value.lowerBits | rhs.value.lowerBits

    lhs = UInt128(upperBits: upperBits, lowerBits: lowerBits)
  }

  /// Performs a bitwise XOR operation on 2 UInt128 data types.
  public static func ^= (lhs: inout UInt128, rhs: UInt128) {
    let upperBits = lhs.value.upperBits ^ rhs.value.upperBits
    let lowerBits = lhs.value.lowerBits ^ rhs.value.lowerBits

    lhs = UInt128(upperBits: upperBits, lowerBits: lowerBits)
  }

  /// Perform a masked right SHIFT operation self.
  ///
  /// The masking operation will mask `rhs` against the highest
  /// shift value that will not cause an overflowing shift before
  /// performing the shift. IE: `rhs = 128` will become `rhs = 0`
  /// and `rhs = 129` will become `rhs = 1`.
  public static func &>>= (lhs: inout UInt128, rhs: UInt128) {
    let shiftWidth = rhs.value.lowerBits & 127

    switch shiftWidth { case 0: return  // Do nothing shift.
      case 1...63:
        let upperBits = lhs.value.upperBits >> shiftWidth
        let lowerBits =
          (lhs.value.lowerBits >> shiftWidth) + (lhs.value.upperBits << (64 - shiftWidth))
        lhs = UInt128(upperBits: upperBits, lowerBits: lowerBits)

      case 64:
        // Shift 64 means move upper bits to lower bits.
        lhs = UInt128(upperBits: 0, lowerBits: lhs.value.upperBits)

      default:
        let lowerBits = lhs.value.upperBits >> (shiftWidth - 64)
        lhs = UInt128(upperBits: 0, lowerBits: lowerBits)
    }
  }

  /// Perform a masked left SHIFT operation on self.
  ///
  /// The masking operation will mask `rhs` against the highest
  /// shift value that will not cause an overflowing shift before
  /// performing the shift. IE: `rhs = 128` will become `rhs = 0`
  /// and `rhs = 129` will become `rhs = 1`.
  public static func &<<= (lhs: inout UInt128, rhs: UInt128) {
    let shiftWidth = rhs.value.lowerBits & 127

    switch shiftWidth { case 0: return  // Do nothing shift.
      case 1...63:
        let upperBits =
          (lhs.value.upperBits << shiftWidth) + (lhs.value.lowerBits >> (64 - shiftWidth))
        let lowerBits = lhs.value.lowerBits << shiftWidth
        lhs = UInt128(upperBits: upperBits, lowerBits: lowerBits)

      case 64:
        // Shift 64 means move lower bits to upper bits.
        lhs = UInt128(upperBits: lhs.value.lowerBits, lowerBits: 0)

      default:
        let upperBits = lhs.value.lowerBits << (shiftWidth - 64)
        lhs = UInt128(upperBits: upperBits, lowerBits: 0)
    }
  }
}

// MARK: - UnsignedInteger Conformance

extension UInt128: UnsignedInteger {}

// MARK: - Hashable Conformance

extension UInt128: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(value.lowerBits)
    hasher.combine(value.upperBits)
  }
}

// MARK: - Numeric Conformance

extension UInt128: Numeric {
  public static func + (lhs: UInt128, rhs: UInt128) -> UInt128 {
    precondition(~lhs >= rhs, "Addition overflow!")
    let result = lhs.addingReportingOverflow(rhs)
    return result.partialValue
  }

  public static func += (lhs: inout UInt128, rhs: UInt128) { lhs = lhs + rhs }

  public static func - (lhs: UInt128, rhs: UInt128) -> UInt128 {
    precondition(lhs >= rhs, "Integer underflow")
    let result = lhs.subtractingReportingOverflow(rhs)
    return result.partialValue
  }

  public static func -= (lhs: inout UInt128, rhs: UInt128) { lhs = lhs - rhs }

  public static func * (lhs: UInt128, rhs: UInt128) -> UInt128 {
    let result = lhs.multipliedReportingOverflow(by: rhs)
    precondition(!result.overflow, "Multiplication overflow!")
    return result.partialValue
  }

  public static func *= (lhs: inout UInt128, rhs: UInt128) { lhs = lhs * rhs }
}

// MARK: - Equatable Conformance

extension UInt128: Equatable {
  /// Checks if the `lhs` is equal to the `rhs`.
  public static func == (lhs: UInt128, rhs: UInt128) -> Bool {
    if lhs.value.lowerBits == rhs.value.lowerBits, lhs.value.upperBits == rhs.value.upperBits {
      return true
    }
    return false
  }
}

// MARK: - ExpressibleByIntegerLiteral Conformance

extension UInt128: ExpressibleByIntegerLiteral {
  public init(integerLiteral value: IntegerLiteralType) {
    self.init(upperBits: 0, lowerBits: UInt64(value))
  }
}

// MARK: - CustomStringConvertible Conformance

extension UInt128: CustomStringConvertible {
  // MARK: Instance Properties

  public var description: String { _valueToString() }

  // MARK: Instance Methods

  /// Converts the stored value into a string representation based on radix.
  /// - Parameters:
  ///   - radix: The radix for the base numbering system to emit. Default is 10.
  ///   - uppercase: Specify true for uppercase and false for lowercase for returned String.
  /// - Returns: String representation of the stored UInt128 value.
  /// - Precondition: Valid radix is from 2...36
  /// - Complexity: O(n) where n is the number of decimal digits in the final representation
  func _valueToString(radix: Int = 10, uppercase: Bool = true) -> String {
    precondition((2...36) ~= radix, "radix must be within the range of 2-36.")

    // Simple case.
    if self == 0 { return "0" }

    var result = String()
    let radix = UInt128(radix)
    var index: String.Index

    // Reserve maxbuffer size for UInt.max as ASCII for respective radix.
    // ex. print(UInt128.max._valueToString(radix: 2).count)
    switch radix { case 10: result.reserveCapacity(39)

      case 16: result.reserveCapacity(32)

      case 2: result.reserveCapacity(128)

      case 8: result.reserveCapacity(43)

      default:
        // Base3 is next worst case after Base2
        // General for any other radix not enumerated above.
        result.reserveCapacity(81)
    }

    // Used as the check for indexing through UInt128 for string interpolation.
    var divmodResult = (quotient: self, remainder: UInt128(0))
    // Will hold the pool of possible values.
    let characterPool =
      uppercase ? "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ" : "0123456789abcdefghijklmnopqrstuvwxyz"

    // Go through internal value until every base position is string(ed).
    repeat {
      divmodResult = divmodResult.quotient.quotientAndRemainder(dividingBy: radix)
      index = characterPool.index(
        characterPool.startIndex,
        offsetBy: Int(truncatingIfNeeded: divmodResult.remainder.value.lowerBits)
      )
      result.append(characterPool[index])
    } while divmodResult.quotient > 0

    return String(result.reversed())
  }
}

// MARK: - CustomDebugStringConvertible Conformance

extension UInt128: CustomDebugStringConvertible {
  public var debugDescription: String { description }
}

// MARK: - Comparable Conformance

extension UInt128: Comparable {
  public static func < (lhs: UInt128, rhs: UInt128) -> Bool {
    if lhs.value.upperBits < rhs.value.upperBits {
      return true
    }
    else if lhs.value.upperBits == rhs.value.upperBits, lhs.value.lowerBits < rhs.value.lowerBits {
      return true
    }
    return false
  }
}

// MARK: - Codable Conformance

extension UInt128: Codable {
  private enum CodingKeys: String, CodingKey {
    case upperBits
    case lowerBits
  }

  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let upperBits = try container.decode(UInt64.self, forKey: .upperBits)
    let lowerBits = try container.decode(UInt64.self, forKey: .lowerBits)
    self.init(upperBits: upperBits, lowerBits: lowerBits)
  }

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(value.upperBits, forKey: .upperBits)
    try container.encode(value.lowerBits, forKey: .lowerBits)
  }
}

// MARK: - Deprecated API

extension UInt128 {
  /// Initialize a UInt128 value from a string.
  ///
  /// - parameter source: the string that will be converted into a
  ///   UInt128 value. Defaults to being analyzed as a base10 number,
  ///   but can be prefixed with `0b` for base2, `0o` for base8
  ///   or `0x` for base16.
  @available(swift, deprecated: 3.2, renamed: "init(_:)") public static func fromUnparsedString(
    _ source: String
  ) throws -> UInt128 {
    guard let result = UInt128(source) else { throw UInt128Errors.invalidString }
    return result
  }

  /// The required initializer of `ExpressibleByStringLiteral`.
  ///
  /// Note that the `ExpressibleByStringLiteral` conformance has been removed because it
  /// does not handle failures gracefully and it always shadows the failable initializer in Swift 5.
  @available(
    swift,
    deprecated: 5.0,
    message:
      "The ExpressibleByStringLiteral conformance has been removed. Use failable initializer instead.",
    renamed: "init(_:)"
  ) public init(stringLiteral value: StringLiteralType) {
    self.init()

    if let result = UInt128._valueFromString(value) { self = result }
  }
}

// MARK: - BinaryFloatingPoint Interworking

extension BinaryFloatingPoint {
  public init(_ value: UInt128) {
    precondition(
      value.value.upperBits == 0,
      "Value is too large to fit into a BinaryFloatingPoint until a 128bit BinaryFloatingPoint type is defined."
    )
    self.init(value.value.lowerBits)
  }

  public init?(exactly value: UInt128) {
    if value.value.upperBits > 0 { return nil }
    self = Self(value.value.lowerBits)
  }
}

// MARK: - String Interworking

extension String {
  /// Creates a string representing the given value in base 10, or some other
  /// specified base.
  ///
  /// - Parameters:
  ///   - value: The UInt128 value to convert to a string.
  ///   - radix: The base to use for the string representation. `radix` must be
  ///     at least 2 and at most 36. The default is 10.
  ///   - uppercase: Pass `true` to use uppercase letters to represent numerals
  ///     or `false` to use lowercase letters. The default is `false`.
  public init(_ value: UInt128, radix: Int = 10, uppercase: Bool = false) {
    self = value._valueToString(radix: radix, uppercase: uppercase)
  }
}

extension UInt128 {
  static func _valueFromString(_ value: String) -> UInt128? {
    let radix = UInt128._determineRadixFromString(value)
    let inputString = radix == 10 ? value : String(value.dropFirst(2))
    guard inputString.isEmpty == false else { return nil }

    return UInt128(inputString, radix: radix)
  }

  static func _determineRadixFromString(_ string: String) -> Int {
    switch string.prefix(2) { case "0b": 2 case "0o": 8 case "0x": 16 default: 10
    }
  }
}

// swiftlint:enable all