
import Combine

extension RemoteImage {
  static func publisher(from fetch: @escaping  RemoteImageFetcher) -> AnyPublisher<Result<RemoteImage, Error>, Never> {
    return Future { fulfill in
      fetch{
        fulfill(.success($0))
      }
    }.eraseToAnyPublisher()
  }
}
