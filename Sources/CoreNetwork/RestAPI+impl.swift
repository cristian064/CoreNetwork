//
//  File.swift
//  
//
//  Created by cristian ayala on 1/01/22.
//

import GenericUtilities
import Foundation

public extension RestAPI {
    
    func request<ResponseCodable, QueryParam, ParamBody>(with requestUrl: String,
                                                         httpMethod: HttpVerb,
                                                         queryParam: QueryParam,
                                                         paramBody: ParamBody,
                                                         completion: @escaping (ResponseAPI<ResponseCodable>) -> Void) where ResponseCodable: Codable, QueryParam: QueryParamEncodable, ParamBody: Codable{
        guard let url = getURLFromComponent(with: requestUrl, queryParam: queryParam) else {
            completion(.failure(.invalidURL))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        do {
            request.httpBody = try encode(paramBody: paramBody)
        }catch {
            completion(.failure(.jsonEncoderError))
        }
        sessionRequest(with: request, completion: completion)
        
    }
    
    func request<ResponseCodable, ParamBody>(with requestUrl: String,
                                             httpMethod: HttpVerb,
                                             paramBody: ParamBody,
                                             completion: @escaping (ResponseAPI<ResponseCodable>) -> Void) where ResponseCodable: Codable, ParamBody: Codable{
        guard let url = URL(string: requestUrl) else
        {
            completion(.failure(.invalidURL))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        do {
            request.httpBody = try encode(paramBody: paramBody)
        }catch {
            completion(.failure(.jsonEncoderError))
        }
        
        sessionRequest(with: request, completion: completion)
        
    }
    
    func request<ResponseCodable: Codable>(with requestUrl: String,
                                           httpMethod: HttpVerb) async throws -> ResponseCodable {
        guard let url = URL(string: requestUrl) else
        {
            throw NetworkError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        
        return try await withCheckedThrowingContinuation({ continuation in
            sessionRequest(with: request) { (response: ResponseAPI<ResponseCodable>)  in
                continuation.resume(responseAPI: response)
            }
        })
    }
    
    func request<ResponseCodable: Codable>(with requestUrl: String,
                                           httpMethod: HttpVerb,
                                           completion: @escaping (ResponseAPI<ResponseCodable>)) {
        guard let url = URL(string: requestUrl) else {
            completion(.failure(.invalidURL))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        sessionRequest(with: request, completion: completion)
    }
    
}
