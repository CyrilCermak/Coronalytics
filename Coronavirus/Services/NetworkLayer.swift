//
//  NetworkLayer.swift
//  Coronalytics
//
//  Created by Cyril Cermak on 26.03.20.
//  Copyright © Cyril Cermak. All rights reserved.
//

import Foundation

public class NetworkLayer {
    public enum HTTPMethodType: String {
        case get, post, put, delete
        
        public var toString: String {
            switch self {
            case .get: return "GET"
            case .post: return "POST"
            case .put: return "PUT"
            case .delete: return "DELTE"
            }
        }
    }

    private let session = URLSession.shared
    
    public func get(url: URL, body: [String:Any]?, headers: [String:String]? = nil, completion:@escaping(_ data: Data?, _ error: Error?) -> Void ) {
        httpRequest(method: .get, url: url, body: body,headers: headers, completion: completion)
    }
    
    public func post(url: URL, body: [String:Any]?, headers: [String:String]? = nil, completion:@escaping(_ data: Data?, _ error: Error?) -> Void ) {
        httpRequest(method: .post, url: url, body: body, headers: headers, completion: completion)
    }
    
    private func httpRequest(method: HTTPMethodType, url: URL, body: [String:Any]?, headers: [String:String]?, completion:@escaping(_ data: Data?, _ error: Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = method.toString
        headers?.forEach({ request.addValue($0.value, forHTTPHeaderField: $0.key)})
        if let body = body, let json = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted) {
            request.httpBody = json
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            completion(data, error)
        })
        task.resume()
    }
    
}
