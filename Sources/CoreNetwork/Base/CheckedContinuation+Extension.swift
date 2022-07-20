//
//  File.swift
//  
//
//  Created by Cristian Ayala on 18/06/22.
//

import Foundation

extension URLSession {
    func data(urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        try await withCheckedThrowingContinuation { continuation in
            let task = self.dataTask(with: urlRequest) { data, response, error in
                guard let data = data, let response = response else {
                    let error = error ?? URLError(.badServerResponse)
                    return continuation.resume(throwing: error)
                }
                continuation.resume(returning: (data, response))
            }
            task.resume()
        }
    }
}

extension CheckedContinuation {
    func resume(responseAPI: ResponseAPI<T>) {
        switch responseAPI {
        case .success(let response):
            self.resume(returning: response)
        case .failure(let error):
            guard let error = error as? E else { return }
            self.resume(throwing: error)
        }
    }
}


