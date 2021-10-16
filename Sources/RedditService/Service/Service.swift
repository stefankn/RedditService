//
//  Service.swift
//  
//
//  Created by Stefan Klein Nulent on 05/03/2021.
//

import Foundation
import Combine

class Service {
    
    // MARK: - Types
    
    typealias Parameters = [(name: String, value: CustomStringConvertible)]
    
    enum ServiceError: Error {
        case invalidURL
        case failure(response: HTTPURLResponse?, data: Data)
    }
    
    
    
    // MARK: - Properties
    
    var baseURL: URL? { nil }
    var configuration: URLSessionConfiguration { .default }
    
    
    
    // MARK: - Functions
    
    final func get<R: Decodable>(_ path: String, parameters: Parameters? = nil) -> AnyPublisher<R, Error> {
        url(for: path, parameters: parameters)
            .flatMap{ self.request(URLRequest(method: .get, url: $0)) }
            .eraseToAnyPublisher()
    }
    
    final func post<S: Encodable, R: Decodable>(_ path: String, body: S, parameters: Parameters? = nil) -> AnyPublisher<R, Error> {
        url(for: path, parameters: parameters)
            .flatMap{ self.request(URLRequest(method: .post, url: $0), body: body) }
            .eraseToAnyPublisher()
    }
    
    final func post<R: Decodable>(_ path: String, parameters: Parameters? = nil, body: @escaping () throws -> Data?) -> AnyPublisher<R, Error> {
        url(for: path, parameters: parameters)
            .flatMap{ self.request(URLRequest(method: .post, url: $0), body: body) }
            .eraseToAnyPublisher()
    }
    
    func prepare(_ request: URLRequest) -> URLRequest {
        var request = request
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        if let locale = Locale.preferredLanguages.first {
            request.setValue(locale, forHTTPHeaderField: "Accept-Language")
        }
        
        return request
    }
    
    func request<R: Decodable>(_ request: URLRequest) -> AnyPublisher<R, Error> {
        let request = prepare(request)

        let session = URLSession(configuration: configuration)
        return session
            .dataTaskPublisher(for: request)
            .tryMap { (data, response) in
                if let error = self.validate(data: data, response: response) {
                    throw error
                } else {
                    return try self.decode(data)
                }
            }
            .eraseToAnyPublisher()
    }
    
    
    
    // MARK: - Private Functions
    
    private func request<R: Decodable>(_ request: URLRequest, body: () throws -> Data?) -> AnyPublisher<R, Error> {
        do {
            var request = request
            request.httpBody = try body()
            return self.request(request)
        } catch {
            return .failure(error)
        }
    }
    
    
    private func request<S: Encodable, R: Decodable>(_ request: URLRequest, body: S) -> AnyPublisher<R, Error> {
        do {
            var request = request
            request.httpBody = try encode(body)
            return self.request(request)
        } catch {
            return .failure(error)
        }
    }
    
    private func encode<S: Encodable>(_ body: S) throws -> Data {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return try encoder.encode(body)
    }
    
    private func decode<R: Decodable>(_ data: Data) throws -> R {
        //print(String(data: data, encoding: .utf8))
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(R.self, from: data)
    }
    
    private func validate(data: Data, response: URLResponse) -> Error? {
        if (response as? HTTPURLResponse)?.status.isSuccess == true {
            return nil
        } else {
            return ServiceError.failure(response: response as? HTTPURLResponse, data: data)
        }
    }
    
    private func url(for path: String, parameters: Parameters? = nil) -> AnyPublisher<URL, Error> {
        if let url = URL(string: path, relativeTo: baseURL) {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
            if let parameters = parameters {
                let queryItems = (components?.queryItems ?? []) + parameters.map{ URLQueryItem(name: $0.name, value: $0.value.description) }
                components?.queryItems = queryItems
            }
            
            if let url = components?.url {
                print(url)
                return .just(url)
            } else {
                return .failure(ServiceError.invalidURL)
            }
        } else {
            return .failure(ServiceError.invalidURL)
        }
    }
}
