


extension Result {
  func tupleWith<OtherSuccessType>(_ other: Result<OtherSuccessType, Failure>) -> Result<(Success, OtherSuccessType),Failure> {
    self.flatMap { success in
      other.map { other in
        return (success, other)
      }
    }
  }
  
  func unwrap<NewSuccessType>(error: Failure) -> Result<NewSuccessType, Failure> where Success == Optional<NewSuccessType> {
    self.flatMap { optValue in
      guard let value = optValue else {
        return .failure(error)
      }
      return .success(value)
    }
  }
  
  @inlinable public func flatMap<NewSuccess>(_ transform: (Success) async throws -> NewSuccess) async -> Result<NewSuccess, Failure> where Failure == Error {
    let oldSuccess : Success
    
    switch self {
    case .failure(let failure):
      return .failure(failure)
    case .success(let success):
      oldSuccess = success
    }

    let result : Result<NewSuccess, Failure>
    do {
      let newSuccess = try await transform(oldSuccess)
      result = .success(newSuccess)
    } catch {
      result = .failure(error)
    }
    
    return result
  }
}
