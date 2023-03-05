//
//  NetworkKit.swift
//  NetworkKit
//
//  Created by ferhatiltas on 5.03.2023.
//

import Alamofire
import CoreKit
import UIKit

public struct NetworkKit: AnyNetworkKit {
    static let shared = NetworkKit()
    func send<T>(
        path: NetworkPaths,
        requestType: Alamofire.HTTPMethod,
        parseModel: T.Type,
        params: [String: String]?,
        headers: [String: String]?,
        onSuccess: @escaping (T?) -> Void,
        onFail: @escaping (BaseErrorModel?) -> Void
    ) where T: Decodable, T: Encodable {
        let request = AF.request(
            NetworkPaths.baseUrl.rawValue + path.rawValue,
            method: requestType,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: headers == nil ? .default : HTTPHeaders(headers!)
        ).validate()
        request.responseData { response in
            guard let responseData = response.value else {
                guard let errorData = response.data else {
                    onFail(nil)
                    return
                }
                let model = decodeData(data: errorData, parseModel: BaseErrorModel.self)
                onFail(model)
                return
            }

            guard let data = decodeData(data: responseData, parseModel: parseModel) else {
                guard let errorData = response.data else {
                    onFail(nil)
                    return
                }
                let model = decodeData(data: errorData, parseModel: BaseErrorModel.self)
                onFail(model)
                return
            }

            #if DEBUG
            BaseLogger.shared.request(request, didParseResponse: response, responseData: responseData)
            #endif
            onSuccess(data)
        }
    }
}
