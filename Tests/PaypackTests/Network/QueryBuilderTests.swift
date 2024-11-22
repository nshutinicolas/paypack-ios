//
//  QueryBuilderTests.swift
//
//
//  Created by Musoni nshuti Nicolas on 18/11/2024.
//

import XCTest
@testable import Paypack

final class QueryBuilderTests: XCTestCase {
	func test_cashInURL() {
		// Given
		let baseUrl = "https://payments.paypack.rw/api"
		let expectedURL = URL(string: "https://payments.paypack.rw/api/transactions/cashin")
		
		// When
		let generatedURL = QueryBuilder.url(for: .cashIn)
		
		// Then
		XCTAssertEqual(Constants.baseUrl, baseUrl)
		XCTAssertEqual(generatedURL, expectedURL, "The generated URL for cashIn is incorrect.")
	}
	
	func test_cashOutURL() {
		// Given
		let baseUrl = "https://payments.paypack.rw/api"
		let expectedURL = URL(string: "https://payments.paypack.rw/api/transactions/cashout")
		
		// When
		let generatedURL = QueryBuilder.url(for: .cashOut)
		
		// Then
		XCTAssertEqual(Constants.baseUrl, baseUrl)
		XCTAssertEqual(generatedURL, expectedURL, "The generated URL for cashOut is incorrect.")
	}
	
	func test_authenticationURL() {
		// Given
		let baseUrl = "https://payments.paypack.rw/api"
		let expectedURL = URL(string: "https://payments.paypack.rw/api/auth/agents/authorize")
		
		// When
		let generatedURL = QueryBuilder.url(for: .authenticate)
		
		// Then
		XCTAssertEqual(Constants.baseUrl, baseUrl)
		XCTAssertEqual(generatedURL, expectedURL, "The generated URL for authentication is incorrect.")
	}
	
	func test_refreshTokenURL() {
		// Given
		let baseUrl = "https://payments.paypack.rw/api"
		let expectedURL = URL(string: "https://payments.paypack.rw/api/auth/agents/refresh/token_id")
		
		// When
		let generatedURL = QueryBuilder.url(for: .refreshToken(token: "token_id"))
		
		// Then
		XCTAssertEqual(Constants.baseUrl, baseUrl)
		XCTAssertEqual(generatedURL, expectedURL, "The generated URL for authentication is incorrect.")
	}
	
	func test_urlRequestURL() {
		// Given
		let expectedURL = URL(string: "https://payments.paypack.rw/api/transactions/cashin")
		let expectedHTTPMethod = HTTPMethod.GET
		
		// When
		let urlRequest = QueryBuilder.urlRequest(for: .cashIn, method: HTTPMethod.GET)
		
		// Then
		XCTAssertEqual(urlRequest?.httpMethod, expectedHTTPMethod)
		XCTAssertEqual(urlRequest?.url, expectedURL)
	}
}
