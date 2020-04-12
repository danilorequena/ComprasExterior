//
//  AllCurrency.swift
//  ComprasExterior
//
//  Created by Danilo Requena on 11/04/20.
//  Copyright © 2020 Danilo Requena. All rights reserved.
//

import Foundation

// MARK: - AllCurrency
struct AllCurrency: Codable {
    let usd, eur, gbp: Values!

    enum CodingKeys: String, CodingKey {
        case usd = "USD"
        case eur = "EUR"
        case gbp = "GBP"
    }
}

// MARK: - Eur
struct Values: Codable {
    let code, codein, name, high: String!
    let low, varBid, pctChange, bid: String!
    let ask, timestamp, createDate: String!

    enum CodingKeys: String, CodingKey {
        case code, codein, name, high, low, varBid, pctChange, bid, ask, timestamp
        case createDate = "create_date"
    }
}
