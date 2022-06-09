

extension ClosedRange {
    init<Other: Comparable>(_ other: ClosedRange<Other>, _ transform: (Other) -> Bound) {
        self = transform(other.lowerBound)...transform(other.upperBound)
    }
}
