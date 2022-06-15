
import Combine

extension RestoreImage{
    static func publisher(from fetch: @escaping  RemoteRestoreImageFetcher) -> AnyPublisher<Result<RestoreImage, Error>, Never> {
      return Future { fulfill in
        fetch{
          fulfill(.success($0))
        }
      }.eraseToAnyPublisher()
    }
}

//extension RemoteImage {
//  static func publisher(from fetch: @escaping  RemoteImageFetcher) -> AnyPublisher<Result<RemoteImage, Error>, Never> {
//    return Future { fulfill in
//      fetch{
//        fulfill(.success($0))
//      }
//    }.eraseToAnyPublisher()
//  }
//}
