//
//  File.swift
//  
//
//  Created by cristian ayala on 1/01/22.
//

import GenericUtilities

public protocol RestAPI {
    func request<ResponseCodable, QueryParam, ParamBody>(with requestUrl: String,
                                                         httpMethod: HttpVerb,
                                                         queryParam: QueryParam,
                                                         paramBody: ParamBody,
                                                         completion: @escaping (ResponseAPI<ResponseCodable>) -> Void) where ResponseCodable: Codable, QueryParam: QueryParamEncodable, ParamBody: Codable
    func request<ResponseCodable, ParamBody>(with requestUrl: String,
                                             httpMethod: HttpVerb,
                                             paramBody: ParamBody,
                                             completion: @escaping (ResponseAPI<ResponseCodable>) -> Void) where ResponseCodable: Codable, ParamBody: Codable
    func request<ResponseCodable: Codable>(with requestUrl: String,
                                           httpMethod: HttpVerb) async throws -> ResponseCodable
}
