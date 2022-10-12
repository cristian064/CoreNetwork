//
//  File.swift
//  
//
//  Created by cristian ayala on 4/01/22.
//

import Foundation
import GenericUtilities

extension RestAPI {
    func decode<ResponseCodable>(data: Data,
                                         completion: @escaping (ResponseAPI<ResponseCodable>) -> Void) where ResponseCodable: Decodable {
        do{
            let responseCodable = try JSONDecoder().decode(ResponseCodable.self, from: data)
            completion(.success(responseCodable))
        }catch {
            completion(.failure(.jsonDecoderError))
        }
    }
    
    func decode<ResponseCodable: Codable> (type: ResponseCodable.Type, data: Data) throws -> ResponseCodable{
        do{
            let responseCodable = try JSONDecoder().decode(type, from: data)
            return responseCodable
        }catch {
            throw NetworkError.jsonDecoderError
        }
    }
    
    func encode<RequestEncodable>(paramBody: RequestEncodable) throws -> Data? where RequestEncodable: Codable {
        do {
            let encode = try JSONEncoder().encode(paramBody)
            return encode
        } catch {
            throw NetworkError.jsonEncoderError
        }
        
    }
    
    
    func sessionRequest<ResponseCodable>(with urlRequest: URLRequest,
                                                 completion: @escaping (ResponseAPI<ResponseCodable>) -> Void) where ResponseCodable: Decodable {
        let session = SessionManager.shared.session
        session.dataTask(with: urlRequest) { data, urlResponse, error in
            if let error = error {
                completion(.failure(.dataTaskError(error)))
                return
            }
            guard let data = data else{
                return
            }

            decode(data: data, completion: completion)

        }.resume()
    }
    
    func getURLFromComponent<QueryParam>(with requestUrl: String,
                                         queryParam: QueryParam) ->URL? where QueryParam: QueryParamEncodable{
        var components =  URLComponents(string: requestUrl)
        components?.queryItems = queryParam.asDictionar.map { (key,value) in
            return URLQueryItem(name: key, value: "\(value)")
        }
        return components?.url
    }
    
    
    func sessionRequest<ResponseCodable: Codable>(with urlRequest: URLRequest) async throws -> ResponseCodable {
        let session = SessionManager.shared.session
        do {
            let (data, response) = try await session.data(urlRequest: urlRequest)
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw NetworkError.invalidResponse
            }
            let responseDecodable = try JSONDecoder().decode(ResponseCodable.self, from: data)
            return responseDecodable
            
        } catch {
            throw NetworkError.dataTaskError(error)
        }
        
    }
}
