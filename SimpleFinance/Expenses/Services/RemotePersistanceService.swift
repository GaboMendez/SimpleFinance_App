//
//  RemotePersistanceService.swift
//  SimpleFinance
//
//  Created by Gabriel Mendez Reyes on 9/1/26.
//

import Foundation

@Observable
final class RemotePersistenceService : PersitenceServing {
    
    private(set) var expenses: [Expense] = []

    func load() async throws {
        throw NSError(domain: "RemotePersistenceService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Not implemented"])
    }
    
    func getAll() async throws -> [Expense] {
        throw NSError(domain: "RemotePersistenceService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Not implemented"])
    }
    
    func add(_ expense: Expense) async throws {
        throw NSError(domain: "RemotePersistenceService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Not implemented"])
    }
    
    func update(_ expense: Expense) async throws {
        throw NSError(domain: "RemotePersistenceService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Not implemented"])
    }
    
    func delete(_ expense: Expense) async throws {
        throw NSError(domain: "RemotePersistenceService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Not implemented"])
    }
    
    func delete(_ ids: [UUID]) async throws {
        throw NSError(domain: "RemotePersistenceService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Not implemented"])
    }
    
}
