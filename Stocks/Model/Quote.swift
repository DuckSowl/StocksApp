//
//  Quote.swift
//  Stocks
//
//  Created by Anton Tolstov on 08.02.2020.
//  Copyright © 2020 Anton Tolstov. All rights reserved.
//

import Foundation

struct Quote: Decodable {
    var symbol: String
    
    var companyName: String?
    var latestPrice: Double?
    var change: Double?
    
    // Additional Info
    var changePercent: Double?
    var previousVolume: Int?
    var marketCap: Int?
    var week52High: Double?
    var week52Low: Double?
}
