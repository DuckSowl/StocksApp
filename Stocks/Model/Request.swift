//
//  Request.swift
//  Stocks
//
//  Created by Anton Tolstov on 08.02.2020.
//  Copyright © 2020 Anton Tolstov. All rights reserved.
//

import Foundation

struct Request {
    static func requestData(with url: URL, completion: @escaping (Data?) -> ())  {
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            guard err == nil else {
                print("Network error")
                return completion(nil)
            }
            return completion(data)
        }.resume()
    }
    
    static func requestJSON<T>(with url: URL, completion: @escaping (T?) -> ()) where T: Decodable {
        requestData(with: url, completion: { data in
            guard let data = data else {
                print("Missing data error")
                return completion(nil)
            }
            guard let jsonParsed = try? JSONDecoder().decode(T.self, from: data) else {
                print("JSON parsing error")
                return completion(nil)
            }
            
            return completion(jsonParsed)
        })
    }
}
