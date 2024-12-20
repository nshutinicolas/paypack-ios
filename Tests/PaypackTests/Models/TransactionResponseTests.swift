//
//  TransactionResponseTests.swift
//
//
//  Created by Musoni nshuti Nicolas on 18/11/2024.
//

import XCTest
@testable import Paypack

class TransactionResponseTests: XCTestCase {
	func test_decoding_successResponse() throws {
		// Given/When
		let data = try XCTUnwrap(MockResponse.validTransaction)
		let response = try JSONDecoder().decode(TransactionResponse.self, from: data)
		
		// Then
		switch response {
		case .success(let successResponse):
			XCTAssertEqual(successResponse.amount, 1000)
			XCTAssertEqual(successResponse.status, .pending)
			XCTAssertEqual(successResponse.ref, "1234")
			XCTAssertEqual(successResponse.fee, 23)
			XCTAssertEqual(successResponse.timestamp, "2014-05-16T08:28:06.801064-04:00")
			XCTAssertEqual(successResponse.kind, .cashOut)
			XCTAssertEqual(successResponse.client, "078000000")
			XCTAssertEqual(successResponse.merchant, "IJOK9F")
		case .failure:
			XCTFail("Expected success model")
		}
	}
	
	func test_decoding_failureResponse() throws {
		// Given/When
		let data = try XCTUnwrap(MockResponse.validFailure)
		let response = try JSONDecoder().decode(TransactionResponse.self, from: data)
		
		// Then
		switch response {
		case .failure(let failureResponse):
			XCTAssertEqual(failureResponse.message, "failure message")
		case .success:
			XCTFail("Expected failure response")
		}
	}
	
	func test_decoding_invalidFormat() throws {
		// Given/When
		let data = try XCTUnwrap(MockResponse.invalidResponse)
		let response = try JSONDecoder().decode(TransactionResponse.self, from: data)
		
		// Then
		switch response {
		case .failure(let failureResponse):
			XCTAssertEqual(failureResponse.message, "Invalid response")
		case .success:
			XCTFail("Expected failure response")
		}
	}
}
