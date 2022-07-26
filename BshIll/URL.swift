import Foundation

extension URL {
    init (forHandle handle: WindowOpenHandle) {
        var components = Configuration.baseURLComponents
        components.path = handle.path
        guard let url = components.url else {
            preconditionFailure()
        }
        self = url
    }
}
