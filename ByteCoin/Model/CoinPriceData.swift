//
//  CoinPriceData.swift
//  ByteCoin
//
//  Created by Roman Kobzarev on 10.04.2022.
//  Copyright © 2022 The App Brewery. All rights reserved.
//

import Foundation

struct CoinPriceData: Codable {
    let rate: Double
    let asset_id_quote: String
}
