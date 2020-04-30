//
//  APIClient.swift
//  test
//
//  Created by Vaibhav Singh on 30/04/20.
//  Copyright © 2020 Vaibhav Singh. All rights reserved.
//

import Foundation

class APIClient {
    lazy var session: SessionProtocol = URLSession.shared
    
    func loginUser(withName username: String, password: String, completion: @escaping (Token?, Error?) -> ()) {
        let query = "username=\(username)&password=\(password)"
        guard let url = URL(string: "https://awesometodos.com/login?\(query)") else {
            fatalError()
        }
        session.dataTask(with: url) { (data, res, err) in
            guard let data = data else {
                return
            }
            
            let dict = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: String]
            let token: Token?
            if let tokenString = dict?["token"] {
                token = Token(id: tokenString)
            } else {
                token = nil
            }
            
            completion(token, nil)
        }.resume()
    }
}

protocol SessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: SessionProtocol {
    
}

struct Token {
    let id: String
}
