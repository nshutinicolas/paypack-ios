//
//  TransactionResponse.swift
//  
//
//  Created by Musoni nshuti Nicolas on 14/11/2024.
//

import Foundation

public typealias FailureTransactionResponse = FailureResponse

public struct SuccessfulTransactionResponse: Decodable {
	let amount: Int
	let client: String
	let fee: Int
	let merchant: String
	let status: TransactionStatus
	let kind: TransactionKind
	let ref: String
	let timestamp: String // TODO: Make this a Date type
	
	enum CodingKeys: CodingKey {
		case amount
		case client
		case fee
		case merchant
		case status
		case kind
		case ref
		case timestamp
	}
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.amount = try container.decode(Int.self, forKey: .amount)
		self.client = try container.decode(String.self, forKey: .client)
		self.fee = try container.decode(Int.self, forKey: .fee)
		self.merchant = try container.decode(String.self, forKey: .merchant)
		self.status = try container.decode(TransactionStatus.self, forKey: .status)
		self.kind = try container.decode(TransactionKind.self, forKey: .kind)
		self.ref = try container.decode(String.self, forKey: .ref)
		self.timestamp = try container.decode(String.self, forKey: .timestamp)
	}
}

public enum TransactionResponse: Decodable {
	case success(SuccessfulTransactionResponse)
	case failure(FailureTransactionResponse)
	
	enum CodingKeys: CodingKey {
		case success
		case failure
	}
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		if let response = try? container.decode(SuccessfulTransactionResponse.self) {
			self = .success(response)
		} else if let errorResponse = try? container.decode(FailureTransactionResponse.self) {
			self = .failure(errorResponse)
		} else {
			self = .failure(.init(message: "Invalid response"))
		}
	}
}
