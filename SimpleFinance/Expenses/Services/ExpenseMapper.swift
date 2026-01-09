//
//  ExpenseMapper.swift
//  SimpleFinance
//
//  Created by Gabriel Mendez Reyes on 9/1/26.
//

import Foundation

struct ExpenseMapper {
    
    // MARK: - DTO to Domain Model
    
    static func toDomain(_ dto: ExpenseDTO) -> Expense {
        var expense = Expense(
            note: dto.title,
            type: ExpenseType(rawValue: dto.type) ?? .other,
            amount: dto.amount,
            date: Date(timeIntervalSince1970: dto.date / 1000) // Convert milliseconds to seconds
        )
        expense.id = UUID(uuidString: dto.id) ?? UUID()
        
        if let lat = dto.locationLatitude,
           let lon = dto.locationLongitude {
            expense.locationInfo = LocationInfo(
                latitude: lat,
                longitude: lon,
                name: dto.locationName
            )
        }
        
        return expense
    }
    
    // MARK: - Domain Model to DTO
    
    static func toRequest(_ expense: Expense) -> CreateExpenseRequest {
        CreateExpenseRequest(
            title: expense.title,
            type: expense.type.rawValue,
            amount: expense.amount,
            date: ISO8601DateFormatter().string(from: expense.date),
            locationInfo: expense.locationInfo.map { toDTO($0) }
        )
    }
    
    static func toDTO(_ locationInfo: LocationInfo) -> LocationInfoDTO {
        LocationInfoDTO(
            latitude: locationInfo.latitude,
            longitude: locationInfo.longitude,
            name: locationInfo.name
        )
    }
}
