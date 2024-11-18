//
//  TransactionPayloadTests.swift
//
//
//  Created by Musoni nshuti Nicolas on 18/11/2024.
//

import XCTest
@testable import Paypack

final class TransactionPayloadTests: XCTestCase {
	func test_isPhoneNumberValid() {
		// Given
		let validNumber = "0781234567"
		
		// When
		let payload = TransactionPayload(amount: 100, phoneNumber: validNumber)
		
		// Then
		XCTAssertTrue(payload.isPhoneNumberValid)
	}
	
	func test_isPhoneNumberValid_with_countrCode() {
		// Given
		let validNumber = "+250781234567"
		
		// When
		let payload = TransactionPayload(amount: 100, phoneNumber: validNumber)
		
		// Then
		XCTAssertTrue(payload.isPhoneNumberValid)
	}
	
	func test_isPhoneNumberValid_with_incompleteNumber() {
		// Given
		let invalidNumber = "1223"
		
		// When
		let payload = TransactionPayload(amount: 100, phoneNumber: invalidNumber)
		
		// Then
		XCTAssertFalse(payload.isPhoneNumberValid)
	}
	
	func test_isPhoneNumberValid_with_invalidProvider() {
		// Given
		let invalidNumber = "0712345678"
		
		// When
		let payload = TransactionPayload(amount: 100, phoneNumber: invalidNumber)
		
		// Then
		XCTAssertFalse(payload.isPhoneNumberValid)
	}
	
	func test_isAmountValid() {
		// Given
		let validAmount: CGFloat = 1000
		
		// When
		let payload = TransactionPayload(amount: validAmount, phoneNumber: "")
		
		// Then
		XCTAssertTrue(payload.isAmountValid)
	}
	
	func test_isAmountValid_lessThan100() {
		// Given
		let invalidAmount:CGFloat = 60
		
		// When
		let payload = TransactionPayload(amount: invalidAmount, phoneNumber: "")
		
		// Then
		XCTAssertFalse(payload.isAmountValid)
	}
}
