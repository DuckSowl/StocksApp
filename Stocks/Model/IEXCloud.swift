//
//  IEXCloud.swift
//  Stocks
//
//  Created by Anton Tolstov on 08.02.2020.
//  Copyright © 2020 Anton Tolstov. All rights reserved.
//

import Foundation

struct IEXCloud {
    private let api = "https://cloud.iexapi.com/stable/stock/"
    private let token = "pk_472b2c5914d64888895fadae1217229f"
    
    private let list = "market/list/iexvolume"
    private let listLimit = 100 - 1
    
    private let filter = "symbol,companyName,latestPrice,change"
    private let additionalFilter = ",changePercent,open,close,high,"
        + "low,volume,previousVolume,marketCap,week52High,week52Low"
    
    var getSymbolsURL: URL? {
        return URL(string: "\(api)\(list)?filter=symbol&listLimit=\(listLimit)&token=\(token)")
    }
    
    func getQuoteURL(for symbol: String,
                     additionalInfo: Bool) -> URL? {
        return URL(string: "\(api)\(symbol)/quote/?filter=\(filter)"
            + "\(additionalInfo ? additionalFilter : "")&token=\(token)")
    }
    
    func getLogoURL(for symbol: String) -> URL? {
        return URL(string: "https://cloud.iexapis.com/stable/stock/\(symbol)/logo/?token=\(token)")
    }
}
