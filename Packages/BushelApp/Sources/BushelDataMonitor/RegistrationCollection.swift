//
// RegistrationCollection.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftData)
  import BushelLogging
  import Foundation

  internal actor RegistrationCollection: Loggable {
    static var loggingCategory: BushelLogging.Category {
      .application
    }

    var registrations = [String: DataAgent]()

    nonisolated func notify(_ update: any DatabaseChangeSet) {
      Task {
        await self.onUpdate(update)
        Self.logger.debug("Notification Complete")
      }
    }

    nonisolated func add(withID id: String, force: Bool, agent: @Sendable @escaping () async -> DataAgent) {
      Task {
        await self.append(withID: id, force: force, agent: agent)
      }
    }

    func append(withID id: String, force: Bool, agent: @Sendable @escaping () async -> DataAgent) async {
      if let registration = self.registrations[id], force {
        Self.logger.debug("Overwriting \(id). Already exists.")
        await registration.finish()
      } else if self.registrations[id] != nil {
        Self.logger.debug("Can't register \(id). Already exists.")
        return
      }
      Self.logger.debug("Registering \(id)")
      let agent = await agent()
      agent.onCompleted {
        Task {
          await self.remove(withID: id, agentID: agent.agentID)
        }
      }
      self.registrations[id] = agent
      Self.logger.debug("Registration Count \(self.registrations.count)")
    }

    func remove(withID id: String, agentID: UUID) {
      guard let agent = self.registrations[id] else {
        Self.logger.warning("No matching registration with id: \(id)")
        return
      }
      guard agent.agentID == agentID else {
        Self.logger.warning("No matching registration with agentID: \(agentID)")
        return
      }
      self.registrations.removeValue(forKey: id)
      Self.logger.debug("Registration Count \(self.registrations.count)")
    }

    func onUpdate(_ update: any DatabaseChangeSet) {
      for (id, registration) in self.registrations {
        Self.logger.debug("Notifying \(id)")
        registration.onUpdate(update)
      }
    }
  }
#endif