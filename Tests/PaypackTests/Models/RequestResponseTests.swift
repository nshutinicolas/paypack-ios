//
//  RequestResponseTests.swift
//  
//
//  Created by Musoni nshuti Nicolas on 23/11/2024.
//

import XCTest
@testable import Paypack

final class RequestResponseTests: XCTestCase {
	func test_decoding_successResponse() throws {
		// Given/When
		let data = try XCTUnwrap(MockResponse.validRequest)
		let response = try JSONDecoder().decode(RequestResponse.self, from: data)
		
		// Then
		switch response {
		case .success(let successResponse):
			XCTAssertEqual(successResponse.amount, 2000)
			XCTAssertEqual(successResponse.status, .success)
			XCTAssertEqual(successResponse.ref, "1234")
			XCTAssertEqual(successResponse.provider, .airtel)
			XCTAssertEqual(successResponse.createdAt, "2024-11-18T12:00:00Z")
			XCTAssertEqual(successResponse.kind, .cashOut)
		case .failure:
			XCTFail("Expected success model")
		}
	}
	
	func test_decoding_failureResponse() throws {
		// Given/When
		let data = try XCTUnwrap(MockResponse.validFailure)
		let response = try JSONDecoder().decode(RequestResponse.self, from: data)
		
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
		let response = try JSONDecoder().decode(RequestResponse.self, from: data)
		
		// Then
		switch response {
		case .failure(let failureResponse):
			XCTAssertEqual(failureResponse.message, "Invalid response")
		case .success:
			XCTFail("Expected failure response")
		}
	}
}
