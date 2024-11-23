//
//  TransactionKind.swift
//  
//
//  Created by Musoni nshuti Nicolas on 23/11/2024.
//

import Foundation

public enum TransactionKind: String, Decodable {
	case cashIn = "CASHIN"
	case cashOut = "CASHOUT"
}
