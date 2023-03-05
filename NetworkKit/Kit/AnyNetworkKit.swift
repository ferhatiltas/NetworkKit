//
//  AnyNetworkKit.swift
//  NetworkKit
//
//  Created by ferhatiltas on 5.03.2023.
//

import Alamofire
import CoreKit
import UIKit

protocol AnyNetworkKit {
    func send<T: Codable>(
        path: NetworkPaths,
        requestType: HTTPMethod,
        parseModel: T.Type,
        params: [String: String]?,
        headers: [String: String]?,
        onSuccess: @escaping (T?) -> Void,
        onFail: @escaping (BaseErrorModel?) -> Void)

    func decodeData<T: Codable>(data: Data, parseModel: T.Type) -> T?
}

extension AnyNetworkKit {
    func decodeData<T: Codable>(data: Data, parseModel: T.Type) -> T? {
        do {
            let data = try JSONDecoder().decode(T.self, from: data)
            return data
        } catch _ {
            return nil
        }
    }
}
