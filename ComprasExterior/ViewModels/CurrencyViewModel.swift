//
//  CurrencyViewModel.swift
//  ComprasExterior
//
//  Created by Danilo Requena on 11/04/20.
//  Copyright © 2020 Danilo Requena. All rights reserved.
//

import UIKit
import Foundation

struct CurrencyViewModel {
    let currency: AllCurrency!
    
    init(currency: AllCurrency) {
        self.currency = currency
    }
}
