



protocol RestoreImageLoader {
  
  func load(from file: FileAccessor) async throws -> RestoreImage
}
