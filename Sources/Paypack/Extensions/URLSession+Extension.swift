//
//  URLSession+Extension.swift
//  
//
//  Created by Musoni nshuti Nicolas on 18/11/2024.
//

import Foundation

protocol URLSessionProtocol {
	func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}
