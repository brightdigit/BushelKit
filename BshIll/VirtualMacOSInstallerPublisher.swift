
import Virtualization
import Combine

class VirtualMacOSInstallerPublisher : VirtualInstaller {
  internal init(vzInstaller: VZMacOSInstaller) {
    self.vzInstaller = vzInstaller
    self.beginTrigger = PassthroughSubject()
    self.installationResultSubject = PassthroughSubject()
    self.cancellable = self.beginTrigger.flatMap {
      return Future { completed in
        self.vzInstaller.install { result in
          completed(.success(result))
        }
      }
    }.subscribe(self.installationResultSubject)
  }
  
  let vzInstaller : VZMacOSInstaller
  let beginTrigger : PassthroughSubject<Void, Never>
  let installationResultSubject : PassthroughSubject<Result<Void, Error>, Never>
  var cancellable : AnyCancellable!
  
  func progressPublisher<Value>(forKeyPath keyPath: KeyPath<Progress, Value>) -> AnyPublisher<Value, Never> {
    return vzInstaller.progress.publisher(for: keyPath, options: [.new, .initial]).eraseToAnyPublisher()
  }
  
  func completionPublisher() -> AnyPublisher<Error?, Never> {
    return self.installationResultSubject.map { result in
      guard case let .failure(error) = result else {
        return nil
      }
      return error
    }.eraseToAnyPublisher()
  }
  
  func begin () {
    self.beginTrigger.send()
  }
  
}
