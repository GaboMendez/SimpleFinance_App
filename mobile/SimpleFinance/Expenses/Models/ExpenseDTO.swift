//
//  ExpenseDTO.swift
//  SimpleFinance
//
//  Created by Gabriel Mendez Reyes on 9/1/26.
//

import Foundation

// MARK: - API Response Models

struct ExpenseDTO: Codable {
    let id: String
    let title: String
    let type: String
    let amount: Double
    let date: Double // milliseconds since epoch
    let locationLatitude: Double?
    let locationLongitude: Double?
    let locationName: String?
}

// MARK: - API Request Models

struct CreateExpenseRequest: Codable {
    let title: String
    let type: String
    let amount: Double
    let date: String // ISO 8601 format
    let locationInfo: LocationInfoDTO?
}

struct LocationInfoDTO: Codable {
    let latitude: Double
    let longitude: Double
    let name: String?
}

struct DeleteExpensesRequest: Codable {
    let ids: [String]
}
