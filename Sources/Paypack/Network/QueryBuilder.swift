//
//  QueryBuilder.swift
//  
//
//  Created by Musoni nshuti Nicolas on 18/11/2024.
//

import Foundation

enum QueryBuilder {
	enum URLPath: String {
		case cashIn = "/transactions/cashin"
		case cashOut = "/transactions/cashout"
		case authenticate = "/auth/agents/authorize"
	}
	
	static func url(for path: URLPath) -> URL? {
		var urlComponents = URLComponents(string: Constants.baseUrl)
		urlComponents?.path += path.rawValue
		
		return urlComponents?.url
	}
}
