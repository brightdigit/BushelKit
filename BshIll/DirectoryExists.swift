


enum DirectoryExists {
  case directoryExists
  case fileExists
  case notExists
}


extension DirectoryExists  {
  init (fileExists: Bool, isDirectory: Bool) {
    if fileExists {
      self = isDirectory ? .directoryExists : .fileExists
    } else {
      self = .notExists
    }
  }
}
