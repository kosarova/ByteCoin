//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation
import UIKit
protocol CoinManagerDelegate {
    func didFailWithError(error: Error)
    func didUpdatePrice(_ coinManager: CoinManager, coinPrice: CoinPriceModel)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "00F42EDA-ACEC-4925-9F90-31936F65C557"
    
    let currencyArray = ["AUD","BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY",
                         "MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var delegate : CoinManagerDelegate?
    
    func getCoinPrice(for selectedCurrency: String) {
        let urlString = "\(baseURL)/\(selectedCurrency)?apikey=\(apiKey)"
        performRequest(with: urlString)
    }
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let bitcoinPrice = parseJSON(safeData) {
                        delegate?.didUpdatePrice(self, coinPrice: bitcoinPrice)
                    }
                }
            }
            task.resume()
        }
    }
    func parseJSON(_ data: Data) -> CoinPriceModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinPriceData.self, from: data)
            let lastPrice = decodedData.rate
            let currencyName = decodedData.asset_id_quote
            let coinPrace = CoinPriceModel(price: lastPrice, currencyName: currencyName)
            return coinPrace
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
