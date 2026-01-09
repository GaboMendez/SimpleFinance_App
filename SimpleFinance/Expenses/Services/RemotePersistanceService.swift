//
//  RemotePersistanceService.swift
//  SimpleFinance
//
//  Created by Gabriel Mendez Reyes on 9/1/26.
//

import Foundation

@Observable
final class RemotePersistenceService: PersitenceServing {
    static let shared = RemotePersistenceService()
    
    private init() {}
    
    private(set) var expenses: [Expense] = []
    private let baseURL = "http://localhost:3000"
    
    // MARK: - Protocol Methods
    
    func load() async throws {
        expenses = try await getAll()
    }
    
    func getAll() async throws -> [Expense] {
        let url = try buildURL(path: "/expenses")
        let (data, response) = try await URLSession.shared.data(from: url)
        try validateResponse(response)
        
        let dtos = try JSONDecoder().decode([ExpenseDTO].self, from: data)
        return dtos.map { ExpenseMapper.toDomain($0) }
    }
    
    func add(_ expense: Expense) async throws {
        let url = try buildURL(path: "/expenses")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(ExpenseMapper.toRequest(expense))
        
        let (_, response) = try await URLSession.shared.data(for: request)
        try validateResponse(response)
        
        try await load()
    }
    
    func update(_ expense: Expense) async throws {
        let url = try buildURL(path: "/expenses/\(expense.id.uuidString.lowercased())")
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(ExpenseMapper.toRequest(expense))
        
        let (_, response) = try await URLSession.shared.data(for: request)
        try validateResponse(response)
        
        try await load()
    }
    
    func delete(_ expense: Expense) async throws {
        let url = try buildURL(path: "/expenses/\(expense.id.uuidString.lowercased())")
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let (_, response) = try await URLSession.shared.data(for: request)
        try validateResponse(response)
        
        try await load()
    }
    
    func delete(_ ids: [UUID]) async throws {
        let url = try buildURL(path: "/expenses")
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody = DeleteExpensesRequest(ids: ids.map { $0.uuidString.lowercased() })
        request.httpBody = try JSONEncoder().encode(requestBody)
        
        let (_, response) = try await URLSession.shared.data(for: request)
        try validateResponse(response)
        
        try await load()
    }
    
    // MARK: - Private Helpers
    
    private func buildURL(path: String) throws -> URL {
        guard let url = URL(string: "\(baseURL)\(path)") else {
            throw URLError(.badURL)
        }
        return url
    }
    
    private func validateResponse(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
    }
    
}
