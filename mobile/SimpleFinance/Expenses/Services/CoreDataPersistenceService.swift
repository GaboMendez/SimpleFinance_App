//
//  CoreDataPersistenceService.swift
//  SimpleFinance
//
//  Created by Gabriel Mendez Reyes on 15/2/26.
//

import CoreData
import Foundation

@Observable
final class CoreDataPersistenceService: PersitenceServing {
    static let shared = CoreDataPersistenceService()
    
    private init() {}
    
    private let coreDataManager = CoreDataManager.shared
    private(set) var expenses: [Expense] = []
    
    // MARK: - Protocol Methods
    
    func load() async throws {
        expenses = try await getAll()
    }
    
    func getAll() async throws -> [Expense] {
        let context = coreDataManager.context
        let request = NSFetchRequest<ExpenseEntity>(entityName: "ExpenseEntity")
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        return try await context.perform {
            let entities = try context.fetch(request)
            return entities.compactMap { self.toExpense($0) }
        }
    }
    
    func add(_ expense: Expense) async throws {
        let context = coreDataManager.context
        
        try await context.perform {
            let entity = ExpenseEntity(context: context)
            self.updateEntity(entity, from: expense)
            try context.save()
        }
        
        try await load()
    }
    
    func update(_ expense: Expense) async throws {
        let context = coreDataManager.context
        let request = NSFetchRequest<ExpenseEntity>(entityName: "ExpenseEntity")
        request.predicate = NSPredicate(format: "id == %@", expense.id as CVarArg)
        
        try await context.perform {
            let entities = try context.fetch(request)
            guard let entity = entities.first else {
                throw NSError(domain: "CoreDataPersistenceService", code: 404, userInfo: [NSLocalizedDescriptionKey: "Expense not found"])
            }
            
            self.updateEntity(entity, from: expense)
            try context.save()
        }
        
        try await load()
    }
    
    func delete(_ expense: Expense) async throws {
        let context = coreDataManager.context
        let request = NSFetchRequest<ExpenseEntity>(entityName: "ExpenseEntity")
        request.predicate = NSPredicate(format: "id == %@", expense.id as CVarArg)
        
        try await context.perform {
            let entities = try context.fetch(request)
            guard let entity = entities.first else {
                throw NSError(domain: "CoreDataPersistenceService", code: 404, userInfo: [NSLocalizedDescriptionKey: "Expense not found"])
            }
            
            context.delete(entity)
            try context.save()
        }
        
        try await load()
    }
    
    func delete(_ ids: [UUID]) async throws {
        let context = coreDataManager.context
        let request = NSFetchRequest<ExpenseEntity>(entityName: "ExpenseEntity")
        request.predicate = NSPredicate(format: "id IN %@", ids)
        
        try await context.perform {
            let entities = try context.fetch(request)
            for entity in entities {
                context.delete(entity)
            }
            try context.save()
        }
        
        try await load()
    }
    
    // MARK: - Private Helpers
    
    private func toExpense(_ entity: ExpenseEntity) -> Expense? {
        guard let id = entity.id,
              let title = entity.title,
              let typeString = entity.type,
              let type = ExpenseType(rawValue: typeString),
              let date = entity.date else {
            return nil
        }
        
        var expense = Expense(note: title, type: type, amount: entity.amount, date: date)
        expense.id = id
        
        // Attachment
        if let attachmentId = entity.attachmentId,
           let fileName = entity.attachmentFileName,
           let contentType = entity.attachmentContentType {
            expense.attachment = AttachmentInfo(
                id: attachmentId,
                fileName: fileName,
                contentType: contentType
            )
        }
        
        // Location
        if entity.locationLatitude != 0 || entity.locationLongitude != 0 {
            expense.locationInfo = LocationInfo(
                latitude: entity.locationLatitude,
                longitude: entity.locationLongitude,
                name: entity.locationName
            )
        }
        
        return expense
    }
    
    private func updateEntity(_ entity: ExpenseEntity, from expense: Expense) {
        entity.id = expense.id
        entity.title = expense.title
        entity.type = expense.type.rawValue
        entity.amount = expense.amount
        entity.date = expense.date
        
        // Attachment
        entity.attachmentId = expense.attachment?.id
        entity.attachmentFileName = expense.attachment?.fileName
        entity.attachmentContentType = expense.attachment?.contentType
        
        // Location
        entity.locationLatitude = expense.locationInfo?.latitude ?? 0
        entity.locationLongitude = expense.locationInfo?.longitude ?? 0
        entity.locationName = expense.locationInfo?.name
    }
}
