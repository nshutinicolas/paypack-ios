//
//  RequestResponse.swift
//  
//
//  Created by Musoni nshuti Nicolas on 23/11/2024.
//

import Foundation

public typealias FailureRequestResponse = FailureResponse

public enum RequestResponse: Decodable {
	case success(SuccessfulRequestResponse)
	case failure(FailureRequestResponse)
	
	enum CodingKeys: CodingKey {
		case success
		case failure
	}
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		if let response = try? container.decode(SuccessfulRequestResponse.self) {
			self = .success(response)
		} else if let errorResponse = try? container.decode(FailureRequestResponse.self) {
			self = .failure(errorResponse)
		} else {
			self = .failure(.init(message: "Invalid response"))
		}
	}
}

public struct SuccessfulRequestResponse: Decodable {
	let amount: Int
	let status: TransactionStatus
	let kind: TransactionKind
	let ref: String
	let createdAt: String // TODO: Make this a Date type
	let provider: Provider?
	
	enum CodingKeys: String, CodingKey {
		case amount
		case status
		case kind
		case ref
		case createdAt = "created_at"
		case provider
	}
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.amount = try container.decode(Int.self, forKey: .amount)
		self.status = try container.decode(TransactionStatus.self, forKey: .status)
		self.kind = try container.decode(TransactionKind.self, forKey: .kind)
		self.ref = try container.decode(String.self, forKey: .ref)
		self.createdAt = try container.decode(String.self, forKey: .createdAt)
		self.provider = try container.decodeIfPresent(Provider.self, forKey: .provider)
	}
}
