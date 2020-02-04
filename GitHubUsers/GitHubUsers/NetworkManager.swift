//
//  NetworkManager.swift
//  GitHubUsers
//
//  Created by Arsenkin Bogdan on 02.02.2020.
//  Copyright © 2020 Arsenkin Bogdan. All rights reserved.
//

import Foundation

final class NetworkManager<T: Codable> {
    
    private var task: URLSessionDataTask?
    
    
    
    func requestData(with url: URL, fail: @escaping (String) -> (), success: @escaping (T) -> ()) {
        
        func responceError(description: String) {
            DispatchQueue.main.async {
                fail(description)
            }
        }
        
        task = URLSession.shared.dataTask(with: url, completionHandler: { maybeData, maybeResponse, maybeError in
            
            var data = Data()
            
            if let error = maybeError as NSError? {
                if error.code == -999 {
                    
                    return
                }
            }
            
            if let error = maybeError {
                responceError(description: error.localizedDescription)
                return
            }
            
            guard let httpResponse = maybeResponse as? HTTPURLResponse else {
                responceError(description: "No response object")
                return
            }
            
            let errorCode = httpResponse.statusCode
            
            switch errorCode {
            case 200...299:
                guard let successData = maybeData else {
                    responceError(description: "No data")
                    return
                }
                
                data = successData
            default:
                let message = HTTPURLResponse.localizedString(forStatusCode: errorCode)
                responceError(description: "\(errorCode)\n\(message)")
            }
            
            do {
                let responces = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    success(responces)
                }
            } catch let error {
                responceError(description: "Error serializing json data: \(error.localizedDescription)")
            }
        })
        
        task?.resume()
    }
    
    func cancel() {
        task?.cancel()
    }
    
}
