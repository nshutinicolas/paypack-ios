//
//  NetworkManagerTests.swift
//
//
//  Created by Musoni nshuti Nicolas on 18/11/2024.
//

import XCTest
@testable import Paypack

final class NetworkManagerTests: XCTestCase {
	private var mockSession: MockURLSession!
	private var networkManager: NetworkManager!
	
	override func setUp() {
		super.setUp()
		
		mockSession = MockURLSession()
		let configs = Configs(clientId: "client_id", clientSecret: "secret")
		networkManager = NetworkManager(configs: configs, environment: .dev, session: mockSession)
	}
	
	override func tearDown() {
		mockSession = nil
		networkManager = nil
		
		super.tearDown()
	}
	
	func test_sendRequestWithValidPayload_cashIn() async throws {
		// TODO: Work on Transaction unit tests
//		// Given
//		let payload = RequestPayload(amount: 100, phoneNumber: "0721234567")
//		let responseJson = MockResponse.validRequest
//		mockSession.data = responseJson
//		
//		// When
//		let response = try await networkManager.sendRequest(for: .cashIn, payload: payload)
//		
//		// Then
//		switch response {
//		case .success(let successResponse):
//			XCTAssertEqual(successResponse.amount, 200)
//			XCTAssertEqual(successResponse.status, .success)
//			XCTAssertEqual(successResponse.kind, .cashIn)
//			XCTAssertEqual(successResponse.ref, "12345")
//		case .failure:
//			XCTFail("Expected success response but got failure.")
//		}
	}
}
