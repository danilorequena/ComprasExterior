//
//  Service.swift
//  ComprasExterior
//
//  Created by Danilo Requena on 11/04/20.
//  Copyright © 2020 Danilo Requena. All rights reserved.
//

import Foundation

enum Err {
    case url
    case taskError(error: Error)
    case noResponse
    case noData
    case responseStatusCode(code: Int)
    case invalidJSON
}

class Service {
    private static let urlString = "http://economia.awesomeapi.com.br/json/all/USD-BRL,EUR-BRL,GBP-BRL"
    
    class func loadCurrencys(onComplete: @escaping (AllCurrency?) -> Void, onError: @escaping (Err) -> Void) {
        guard let url = URL(string: urlString) else {
            onError(.url)
            return
        }
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error == nil {
                guard let response = response as? HTTPURLResponse else {
                    onError(.noResponse)
                    return
                }
                if response.statusCode == 200 {
                    guard let data = data else { return }
                    do {
                        let currencys = try JSONDecoder().decode(AllCurrency.self, from: data)
                        onComplete(currencys)
                    } catch let jsonErr {
                        onError(.invalidJSON)
                        print("Error serializing json:", jsonErr)
                    }
                } else {
                    onError(.responseStatusCode(code: response.statusCode))
                    print("Algo deu errado no servidor")
                }
            } else {
                onError(.taskError(error: error!))
                print("Algo deu errado aqui")
            }
        }
        dataTask.resume()
    }
}
