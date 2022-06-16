

//typealias RemoteImageFetcher = (@escaping (Result<RemoteImage,Error>) -> Void) -> Void
typealias RemoteRestoreImageFetcher<RestoreImageMetadataType : RestoreImageMetadata> = (@escaping (Result<RestoreImage<RestoreImageMetadataType>,Error>) -> Void) -> Void
