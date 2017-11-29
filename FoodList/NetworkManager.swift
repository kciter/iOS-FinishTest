//
//  NetworkManager.swift
//  FoodList
//
//  Created by 이선협 on 2017. 11. 29..
//  Copyright © 2017년 이선협. All rights reserved.
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {
        
    }
    
    func request(urlString: String, callback: @escaping (Data) -> Void) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if let data = data {
                
                callback(data)
                
                if let stringData = String(data: data, encoding: .utf8) {
                    print(stringData)
                }
            }
        })
        task.resume()
    }
}
