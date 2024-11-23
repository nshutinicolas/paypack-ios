//
//  QueryBuilder.swift
//  
//
//  Created by Musoni nshuti Nicolas on 18/11/2024.
//

import Foundation

enum QueryBuilder {
	enum Path {
		case authenticate
		case cashIn
		case cashOut
		case refreshToken(token: String)
		case transaction(id: String)
		
		var urlPath: String {
			switch self {
			case .authenticate: return "/auth/agents/authorize"
			case .cashIn: return "/transactions/cashin"
			case .cashOut: return "/transactions/cashout"
			case .refreshToken(let token): return "/auth/agents/refresh/\(token)"
			case .transaction(let id): return "/transactions/find/\(id)"
			}
		}
	}
	
	static func url(for path: Path) -> URL? {
		var urlComponents = URLComponents(string: Constants.baseUrl)
		urlComponents?.path += path.urlPath
		
		return urlComponents?.url
	}
	
	static func urlRequest(
		for path: Path,
		method: String,
		environment: Environment = .dev,
		additionalHeaders: HTTPHeaders = [:]
	) -> URLRequest? {
		var urlComponents = URLComponents(string: Constants.baseUrl)
		urlComponents?.path += path.urlPath
		guard let url = urlComponents?.url else { return nil }
		var urlRequest = URLRequest(url: url)
		urlRequest.httpMethod = method
		let defaultHeaders = defaultHeaders(environment: environment)
		var headers = defaultHeaders.merging(additionalHeaders) { (_, new) in new }
		for header in headers {
			urlRequest.addValue(header.value, forHTTPHeaderField: header.key)
		}
		
		return urlRequest
	}
	
	static private func defaultHeaders(environment: Environment) -> HTTPHeaders {
		[
			"Accept": "application/json",
			"Content-Type": "application/json",
			"X-Webhook-Mode": environment.rawValue
		]
	}
}
