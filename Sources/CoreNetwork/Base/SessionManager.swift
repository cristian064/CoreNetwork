//
//  File.swift
//  
//
//  Created by cristian ayala on 4/01/22.
//

import Foundation

class SessionManager {
    static let shared = SessionManager()
    
    var session: URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.waitsForConnectivity = true
        return URLSession(configuration: configuration)
    }
}
