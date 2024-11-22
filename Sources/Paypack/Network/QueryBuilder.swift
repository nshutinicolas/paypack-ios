//
//  QueryBuilder.swift
//  
//
//  Created by Musoni nshuti Nicolas on 18/11/2024.
//

import Foundation

enum QueryBuilder {
	enum Path {
		case cashIn
		case cashOut
		case authenticate
		case refreshToken(token: String)
		
		var urlPath: String {
			switch self {
			case .cashIn: return "/transactions/cashin"
			case .cashOut: return "/transactions/cashout"
			case .authenticate: return "/auth/agents/authorize"
			case .refreshToken(let token): return "/auth/agents/refresh/\(token)"
			}
		}
	}
	
	static func url(for path: Path) -> URL? {
		var urlComponents = URLComponents(string: Constants.baseUrl)
		urlComponents?.path += path.urlPath
		
		return urlComponents?.url
	}
	
	static func urlRequest(for path: Path, method: String) -> URLRequest? {
		var urlComponents = URLComponents(string: Constants.baseUrl)
		urlComponents?.path += path.urlPath
		guard let url = urlComponents?.url else { return nil }
		var urlRequest = URLRequest(url: url)
		urlRequest.httpMethod = method
		
		return urlRequest
	}
}
