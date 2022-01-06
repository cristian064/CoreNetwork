//
//  File.swift
//  
//
//  Created by cristian ayala on 1/01/22.
//

import GenericUtilities

public protocol RestAPI {
    
    func request<ResponseCodable, QueryParam>(with requestUrl: String,
                                  queryParam: QueryParam,
                                  completion: @escaping (ResponseAPI<ResponseCodable>) -> Void) where ResponseCodable: Codable, QueryParam: QueryParamEncodable
    
    func request<ResponseCodable, ParamBody>(with requestUrl: String,
                                             httpMethod: HttpVerb,
                                             paramBody: ParamBody,
                                             completion: @escaping (ResponseAPI<ResponseCodable>) -> Void) where ResponseCodable: Codable, ParamBody: Codable
}
