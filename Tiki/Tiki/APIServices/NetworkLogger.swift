//
//  NetworkLogger.swift
//  FoodBike
//
//  Created by DINHTRIEU on 7/18/18.
//  Copyright © 2018 dinhtrieuTeam. All rights reserved.
//

import Foundation

class NetworkLogger {
    static func log(request: URLRequest) {
        
        print("\n - - - - - - - - - - OUTGOING - - - - - - - - - - \n")
        defer { print("\n - - - - - - - - - -  END - - - - - - - - - - \n") }
        
        let urlAsString = request.url?.absoluteString ?? ""
        let urlComponents = NSURLComponents(string: urlAsString)
        
        let method = request.httpMethod != nil ? "\(request.httpMethod ?? "")" : ""
        let path = "\(urlComponents?.path ?? "")"
        let query = "\(urlComponents?.query ?? "")"
        let host = "\(urlComponents?.host ?? "")"
        
        var logOutput = """
        \(urlAsString) \n\n
        \(method) \(path)?\(query) HTTP/1.1 \n
        HOST: \(host)\n
        """
        for (key,value) in request.allHTTPHeaderFields ?? [:] {
            logOutput += "\(key): \(value) \n"
        }
        if let body = request.httpBody {
            logOutput += "\n \(NSString(data: body, encoding: String.Encoding.utf8.rawValue) ?? "")"
        }
        
        print(logOutput)
    }
    
    static func log(request: URLRequest, response: URLResponse?, data: Data?) {
        print("\n - - - - - - - - - - RESPONSE - - - - - - - - - - \n")
        defer { print("\n - - - - - - - - - -  END - - - - - - - - - - \n") }
        
        var logOutput = ""
        
        let urlAsString = request.url?.absoluteString ?? ""
        let method = request.httpMethod != nil ? "\(request.httpMethod ?? "")" : ""
        
        logOutput += "-----------------\n \(urlAsString) \n\n \(method) \n-----------------------------------------"
        
        if let response = response as? HTTPURLResponse {
            logOutput += "\n\n STATUS CODE = \(response.statusCode) \n-------------------"
        }
        
        guard let responseData = data else {
            logOutput += "\n NO response Data \n----------"
            print(logOutput)
            return
            
        }
        do {
            let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
            logOutput += "\n\n JSON Data = \(jsonData) \n------------"
        } catch {
            logOutput += "\n Data Eror \n----------"
            print(logOutput)
        }
        
        print(logOutput)
        
    }
    
}
