//
//  NetworkManager.swift
//
//
//  Created by Ali Ersöz on 3/9/24.
//

import Foundation
import Foundation

public class NetworkManager<APIError: Codable> {
    private let session = URLSession.shared
    
    private let configuration: NetworkConfiguration

    public init(configuration: NetworkConfiguration) {
        self.configuration = configuration
    }

    private func createRequest(
        path: String,
        method: HTTPMethod,
        headers: [String: String]? = nil,
        body: Encodable? = nil
    ) throws -> URLRequest {
        guard let url = URL(string: "\(configuration.baseURL)\(path)") else {
            throw NetworkError<APIError>.badURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        if let body {
            request.httpBody = try JSONEncoder().encode(body)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        if let headers {
            headers.forEach({ key, value in
                request.addValue(value, forHTTPHeaderField: key)
            })
        }
        
        return request
    }

    private func decodeResponse<T: Decodable>(
        from data: Data,
        responseType: T.Type
    ) throws -> T {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(responseType, from: data)
            return response
        } catch let error as DecodingError {
            switch error {
            case .keyNotFound(let key, _):
                throw NetworkError<APIError>.keyNotFound(missingKey: key.stringValue)
            default:
                throw NetworkError<APIError>.keyNotFound(missingKey: error.localizedDescription)
            }
        }
    }

    public func performRequest<ResponseType: Decodable>(
        path: String,
        method: HTTPMethod,
        headers: [String: String]? = nil,
        responseType: ResponseType.Type,
        requestBody: Encodable? = nil
    ) async throws -> ResponseType {
        let request: URLRequest
        request = try createRequest(
            path: path,
            method: method,
            headers: headers,
            body: requestBody
        )
        if configuration.logging.printRequest { dump(request) }

        let (data, urlResponse) = try await session.data(for: request)
        let httpResponse = urlResponse as? HTTPURLResponse
        
        if configuration.logging.printResponse { dump(httpResponse) }

        switch httpResponse {
        case .none:
            throw NetworkError<APIError>.errorWithStatusCode(999)

        case .some(let wrappedStatus):
            switch wrappedStatus.statusCode {
            case 400...:
                let decodedResponse = try decodeResponse(from: data, responseType: APIError.self)
                if configuration.logging.printResponse {
                    try printJSON(decodedResponse)
                }

                throw NetworkError<APIError>.api(error: decodedResponse)
            default:
                let decodedResponse = try decodeResponse(from: data, responseType: responseType)

                return decodedResponse
            }
        }
    }
}
