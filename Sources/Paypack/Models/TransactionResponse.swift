//
//  TransactionResponse.swift
//  
//
//  Created by Musoni nshuti Nicolas on 14/11/2024.
//

import Foundation

public struct FailureResponse: Decodable, Error {
	let message: String
}

public enum Provider: String, Decodable {
	case mtn, airtel
}

public enum TransactionStatus: String, Decodable {
	case pending, success, failed
}

public enum TransactionKind: String, Decodable {
	case cashIn = "CASHIN"
	case cashOut = "CASHOUT"
}

public struct SuccessResponse: Decodable {
	let amount: Int
	let status: TransactionStatus
	let kind: TransactionKind
	let ref: String
	let createdAt: String // TODO: Make this a Date type
	let provider: Provider
	
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
		self.provider = try container.decode(Provider.self, forKey: .provider)
	}
}

public enum TransactionResponse: Decodable {
	case success(SuccessResponse)
	case failure(FailureResponse)
	
	enum CodingKeys: CodingKey {
		case success
		case failure
	}
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		if let response = try? container.decode(SuccessResponse.self) {
			self = .success(response)
		} else if let errorResponse = try? container.decode(FailureResponse.self) {
			self = .failure(errorResponse)
		} else {
			self = .failure(.init(message: "Invalid response"))
		}
	}
}
