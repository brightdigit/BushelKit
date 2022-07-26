


struct MockRestoreImageLoader : RestoreImageLoader {
  func load(from file: FileAccessor) async throws -> RestoreImage {
    return try self.actualResult.get()
  }
  
  let actualResult : Result<RestoreImage, Error>
  
  var restoreImageResult: Result<RestoreImage, Error>? {
    return actualResult
  }
}
