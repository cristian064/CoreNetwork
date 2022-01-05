//
//  File.swift
//  
//
//  Created by cristian ayala on 4/01/22.
//

import Foundation

public protocol QueryParamEncodable {
    
}

extension QueryParamEncodable {
    
     var asDictionar: [String: Any] {
        let mirror = Mirror(reflecting: self)
        let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label:String?, value:Any) -> (String, Any)? in
            guard let label = label else { return nil }
            return (label, value)
        }).compactMap { $0 })
        return dict
    }
}
