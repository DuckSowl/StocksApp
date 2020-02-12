//
//  Stocks.swift
//  Stocks
//
//  Created by Anton Tolstov on 08.02.2020.
//  Copyright © 2020 Anton Tolstov. All rights reserved.
//

import UIKit

class Stocks {
    
    private var quotes = [Quote]()
    private var logos = [UIImage?]()
    private let api = IEXCloud()
    
    var count: Int { return quotes.count }
    
    func getQuote(for index: Int,
                  additionalInfo: Bool = false,
                  completion: @escaping (Quote?) -> ()) -> Quote? {
        
        guard isValid(index) else {
            completion(nil)
            return nil
        }
        let oldQuote = quotes[index]

        guard let url = api.getQuoteURL(for: oldQuote.symbol,
                                        additionalInfo: additionalInfo) else {
            completion(nil)
            return oldQuote
        }
        
        Request.requestJSON(with: url) { (newQuote:Quote?) in
            if let newQuote = newQuote {
                self.quotes[index] = newQuote
            }
            
            completion(newQuote)
        }
        
        return oldQuote
    }
    
    func getLogo(for index: Int,
                 completion: @escaping (UIImage?) -> ()) -> UIImage? {
        
        guard isValid(index) else {
            completion(nil)
            return nil
        }
        
        if let logo = logos[index] {
            completion(logo)
            return logo
        }
        
        if let apiLogoUrl = api.getLogoURL(for: quotes[index].symbol) {
            
            Request.requestJSON(with: apiLogoUrl) { (urlDecodable:URLDecodable?) in
                guard let urlDecodable = urlDecodable,
                    let logoURL = URL(string: urlDecodable.url) else {
                        completion(nil)
                        return
                }
                Request.requestData(with: logoURL) { logoData in
                    guard let logoData = logoData,
                        let logoImage = UIImage(data: logoData) else {
                            completion(nil)
                            return
                    }
                    
                    self.logos[index] = logoImage
                    completion(logoImage)
                }
            }
        } else {
            completion(nil)
        }
        
        return nil
    }
    
    func loadSymbols(with count: Int, completion: @escaping (Result)->()) {
        guard let url = api.getSymbolsURL else {
            print("Wrong URL error")
            return completion(.failure)
        }
        
        Request.requestJSON(with: url) { (quotes:[Quote]?) in
            guard let quotes = quotes else {
                return completion(.failure)
            }
            
            self.quotes = quotes
            self.logos = [UIImage?](repeating: nil, count: quotes.count)
            return completion(.success)
        }
    }
    
    private func isValid(_ index: Int) -> Bool {
        return (0 ..< count).contains(index)
    }
}

enum Result {
    case success
    case failure
}

struct URLDecodable: Decodable {
    let url: String
}
