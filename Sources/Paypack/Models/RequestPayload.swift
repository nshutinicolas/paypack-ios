//
//  RequestPayload.swift
//
//
//  Created by Musoni nshuti Nicolas on 18/11/2024.
//

import Foundation

public struct RequestPayload: Encodable {
	let amount: CGFloat
	let number: String
	
	public init(amount: CGFloat, phoneNumber: String) {
		self.amount = amount
		self.number = phoneNumber
	}
	
	var isPhoneNumberValid: Bool {
		let format = #"^(\+?25)?(078|079|075|073|072)\d{7}$"#
		return self.number.range(of: format, options: .regularExpression) != nil
	}
	
	var isAmountValid: Bool {
		amount >= 100
	}
	
	var isValid: Bool {
		isPhoneNumberValid && isAmountValid
	}
}
