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
                                         completion: @escaping (ResponseAPI<ResponseCodable>) -> Void) where ResponseCodable: Codable {
        do{
            let responseCodable = try JSONDecoder().decode(ResponseCodable.self, from: data)
            completion(.success(responseCodable))
        }catch {
            completion(.failure(.init(error: error)))
        }
    }
    
    func encode<RequestEncodable>(paramBody: RequestEncodable) -> Data? where RequestEncodable: Codable {
        do {
            let encode = try JSONEncoder().encode(paramBody)
            return encode
        } catch {
            return nil
        }
        
    }
    
    
    func sessionRequest<ResponseCodable>(with urlRequest: URLRequest,
                                                 completion: @escaping (ResponseAPI<ResponseCodable>) -> Void) where ResponseCodable: Codable {
        let session = SessionManager.shared.session
        session.dataTask(with: urlRequest) { data, urlResponse, error in
            if let error = error {
                completion(.failure(.init(error: error)))
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
}
