
protocol WindowOpenHandle {
  var path : String { get }

}

extension WindowOpenHandle {
  var basic : BasicWindowOpenHandle.Type {
    return BasicWindowOpenHandle.self
  }
}
