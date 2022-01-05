//
//  File.swift
//  
//
//  Created by cristian ayala on 1/01/22.
//

import GenericUtilities
import Foundation

public extension RestAPI {
    
    func request<ResponseCodable, QueryParam>(with requestUrl: String,
                                  queryParam: QueryParam,
                                  completion: @escaping (ResponseAPI<ResponseCodable>) -> Void) where ResponseCodable: Codable, QueryParam: QueryParamEncodable{
                    
        guard let url = getURLFromComponent(with: requestUrl, queryParam: queryParam) else {
            completion(.failure(.init(code: 9000)))
            return
        }
        let request = URLRequest(url: url)
        sessionRequest(with: request, completion: completion)
    }
    
    func request<ResponseCodable, QueryParam, ParamBody>(with requestUrl: String,
                                                         httpMethod: HttpVerb,
                                                         queryParam: QueryParam,
                                                         paramBody: ParamBody,
                                                         completion: @escaping (ResponseAPI<ResponseCodable>) -> Void) where ResponseCodable: Codable, QueryParam: QueryParamEncodable, ParamBody: Codable{
        guard let url = getURLFromComponent(with: requestUrl, queryParam: queryParam) else {
            completion(.failure(.init(code: 9000)))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.httpBody = encode(paramBody: paramBody)
        
        sessionRequest(with: request, completion: completion)
        
    }
    
    func request<ResponseCodable, ParamBody>(with requestUrl: String,
                                             httpMethod: HttpVerb,
                                             paramBody: ParamBody,
                                             completion: @escaping (ResponseAPI<ResponseCodable>) -> Void) where ResponseCodable: Codable, ParamBody: Codable{
        guard let url = URL(string: requestUrl) else
        {
            completion(.failure(.init(code: 9000)))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.httpBody = encode(paramBody: paramBody)
        
        sessionRequest(with: request, completion: completion)
        
    }
    
}
