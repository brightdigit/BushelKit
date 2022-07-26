


protocol ImageContainer {
  var metadata : ImageMetadata { get }
  func installer () async throws -> ImageInstaller 
}
