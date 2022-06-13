//
//  File.swift
//  
//
//  Created by Cristian Ayala on 12/06/22.
//

import Foundation

public enum ResponseAPI<T> {
    case success(T)
    case failure(NetworkError)
}
