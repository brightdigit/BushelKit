

enum BasicWindowOpenHandle : String, CaseIterable, WindowOpenHandle {
    case machine
    case localImages
    case remoteSources
    case welcome
  
  var path: String {
    return self.rawValue
  }
}
