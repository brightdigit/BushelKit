import Foundation
import SwiftUI

class RrisImageCollectionObject : ObservableObject {
    let source : Rris
    
    @Published var imageListResult : Result<[RestoreImage], Error>? = nil
    
    init(source : Rris) {
        self.source = source
    }
    
    
    func loadImages ()  {
        Task {
            let result : Result<[RestoreImage], Error>
            do {
                result = try await .success(self.source.fetch())
            } catch {
                result = .failure(error)
            }
          DispatchQueue.main.async {
            self.imageListResult = result
          }
            
        }
    }
}
