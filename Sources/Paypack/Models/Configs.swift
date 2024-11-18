//
//  Configs.swift
//
//
//  Created by Musoni nshuti Nicolas on 18/11/2024.
//

import Foundation

public struct Configs: Encodable {
	let clientId: String
	let clientSecret: String
	
	public init(clientId: String, clientSecret: String) {
		self.clientId = clientId
		self.clientSecret = clientSecret
	}
	
	enum CodingKeys: String, CodingKey {
		case clientId = "client_id"
		case clientSecret = "client_secret"
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(self.clientId, forKey: .clientId)
		try container.encode(self.clientSecret, forKey: .clientSecret)
	}
}
