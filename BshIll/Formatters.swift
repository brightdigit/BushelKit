import Foundation

enum Formatters {
  static let lastModifiedDateFormatter : DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = $0
    return formatter
  }("E, d MMM yyyy HH:mm:ss Z")
}
