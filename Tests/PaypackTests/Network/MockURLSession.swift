//
//  MockURLSession.swift
//  
//
//  Created by Musoni nshuti Nicolas on 18/11/2024.
//

import Foundation
@testable import Paypack

class MockURLSession: URLSessionProtocol {
	var data: Data?
	var response: URLResponse?
	var error: Error?
	
	func data(for request: URLRequest) async throws -> (Data, URLResponse) {
		if let error = error {
			throw error
		}
		guard let data = data, let response = response else {
			throw URLError(.badServerResponse)
		}
		return (data, response)
	}
}

enum MockResponse {
	static let validSuccess: Data? = {
	"""
	{
		"amount": 2000,
		"status": "success",
		"kind": "CASHOUT",
		"ref": "1234",
		"created_at": "2024-11-18T12:00:00Z",
		"provider": "airtel"
	}
	""".data(using: .utf8)
	}()
	
	static let validFailure: Data? = {
	"""
	{
		"message": "failure message"
	}
	""".data(using: .utf8)
	}()
	
	static let invalidResponse: Data? = {
	"""
	{
		"invalid-key": "invalid value"
	}
	""".data(using: .utf8)
	}()
}
