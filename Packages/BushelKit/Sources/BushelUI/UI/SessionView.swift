//
//  SwiftUIView.swift
//  
//
//  Created by Leo Dion on 8/11/22.
//

import SwiftUI
import BushelMachine
import Combine

class SessionObject :  NSObject, ObservableObject, MachineSessionDelegate {
  @Published var externalURL : URL?
  @Published var machineFileURL: URL?
  @Published var sessionResult : Result<MachineSession, Error>?
  @Published var sessionStartResult : Result<Void, Error>?
  
  func sessionDidStop(_: BushelMachine.MachineSession) {}

  func session(_: BushelMachine.MachineSession, didStopWithError _: Error) {}

  func session(_: BushelMachine.MachineSession, device _: BushelMachine.MachineNetworkDevice, attachmentWasDisconnectedWithError _: Error) {}

  @Published var session: MachineSession? {
    didSet {
    if var session = session {
      session.delegate = self
    }
  }
  }
  
  override init () {
    super.init()
    $externalURL.compactMap(\.?.relativePath).map(URL.init(fileURLWithPath:)).assign(to: &self.$machineFileURL)
    
    $machineFileURL.compactMap{$0}.tryMap(Machine.loadFromURL(_:)).tryMap{
      try $0.createMachine()
    }.map { session in
      session.map(Result.success) ?? Result.failure(MachineError.undefinedType("no session", nil))
    }.catch({ error in
      Just(Result.failure(error))
    }).assign(to: &self.$sessionResult)
            
            let sessionPublisher = self.$sessionResult.compactMap{
      try? $0?.get()
    }
    
    sessionPublisher.map{ (session: MachineSession) in
      
      Future(operation:  { () -> Void in
        
          try await session.begin()
        
      })
    }.switchToLatest().map{ $0 as Optional }.receive(on: DispatchQueue.main).assign(to: &self.$sessionStartResult)
  }
}
struct SessionView: View {
  
  @StateObject var sessionManager  = SessionObject()
    var body: some View {
      Group {
        switch (self.sessionManager.sessionStartResult, self.sessionManager.sessionResult) {
        case (.success, .success(let session)):
          session.view
        case (.failure(let error), _):
          Text(error.localizedDescription)
        case (_, .failure(let error)):
          Text(error.localizedDescription)
          
        case (_, .none):
          ProgressView {
            Text("Creating Session...")
          }
          
        case (.none, .some(.success(_))):
          ProgressView {
            Text("Starting Session...")
          }
          
        }
      }.onOpenURL { externalURL in
        self.sessionManager.externalURL = externalURL
        dump(externalURL)
      }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SessionView()
    }
}
