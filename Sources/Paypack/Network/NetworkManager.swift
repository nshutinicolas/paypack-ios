//
//  NetworkManager.swift
//  
//
//  Created by Musoni nshuti Nicolas on 14/11/2024.
//

import Foundation

enum HTTPMethod {
	static let GET = "GET"
	static let POST = "POST"
}

protocol NetworkManagerProtocol {
	func sendRequest(for transactionKind: TransactionKind, payload: TransactionPayload) async throws -> TransactionResponse
}

final class NetworkManager: NetworkManagerProtocol {
	typealias HTTPHeaders = [String: String]
	private let configs: Configs
	private let environment: Environment
	private let session: URLSessionProtocol
	private let decoder: JSONDecoder
	private let encoder: JSONEncoder
	
	private var authKeys: AuthParams?
	private var authKeyTask: Task<Void, Never>?
	private var timer: Timer?
	
	init(
		configs: Configs,
		environment: Environment,
		session: URLSessionProtocol = URLSession.shared,
		decoder: JSONDecoder = JSONDecoder(),
		encoder: JSONEncoder = JSONEncoder()
	) {
		self.configs = configs
		self.environment = environment
		self.decoder = decoder
		self.encoder = encoder
		self.session = session
		updateAuthkeys(for: configs)
	}
	
	deinit {
		authKeyTask?.cancel()
		timer?.invalidate()
	}
	
	func sendRequest(for transactionKind: TransactionKind, payload: TransactionPayload) async throws -> TransactionResponse {
		guard payload.isValid else {
			throw FailureResponse(message: "Invalid payload content") // String localization
		}
		return try await makeTransaction(for: transactionKind, payload: payload)
	}
	
	private func makeTransaction(for kind: TransactionKind, payload: TransactionPayload) async throws -> TransactionResponse {
		guard let url = QueryBuilder.url(for: kind.urlPath) else {
			throw URLError(.badURL)
		}
		let requestBody = try encoder.encode(payload)
		var urlRequest = try await makeURLRequest(for: url, kind: kind)
		urlRequest.httpBody = requestBody
		
		return try await fetch(TransactionResponse.self, for: urlRequest)
	}
	
	private func makeURLRequest(for url: URL, kind: TransactionKind) async throws -> URLRequest {
		var urlRequest = URLRequest(url: url)
		urlRequest.httpMethod = kind.httpMethod
		var headers = defaultHeaders()
		if let authKeys {
			headers["Authorization"] = authKeys.access
		} else {
			let auth = try await fetchAuthKeys(for: configs)
			headers["Authorization"] = auth.access
		}
		for header in headers {
			urlRequest.addValue(header.value, forHTTPHeaderField: header.key)
		}
		return urlRequest
	}
	
	private func updateAuthkeys(for configs: Configs) {
		authKeyTask = Task { [weak self] in
			guard let self else { return }
			do {
				let authKeys = try await self.fetchAuthKeys(for: configs)
				self.authKeys = authKeys
				// After updating the configs, start the timer to update the auth keys after every 15 mins
				if timer == nil {
					timer = Timer(timeInterval: 900, target: self, selector: #selector(updateAuthKeysByTimer), userInfo: nil, repeats: true)
					timer?.fire()
				}
			} catch {
				// Log this properly
				print("Failed to load auth keys: ", error.localizedDescription)
			}
			self.authKeyTask = nil
		}
	}
	
	@objc
	private func updateAuthKeysByTimer() {
		updateAuthkeys(for: self.configs)
	}
	
	private func fetchAuthKeys(for configs: Configs) async throws -> AuthParams {
		guard let url = QueryBuilder.url(for: .authenticate) else {
			throw URLError(.badURL)
		}
		let httpBody = try encoder.encode(configs)
		var urlRequest = URLRequest(url: url)
		urlRequest.httpMethod = HTTPMethod.POST
		urlRequest.httpBody = httpBody
		return try await self.fetch(AuthParams.self, for: urlRequest)
	}
	
	private func fetch<T:Decodable>(_ model: T.Type, for urlRequest: URLRequest) async throws -> T {
		let (data, response) = try await URLSession.shared.data(for: urlRequest)
		guard let response = response as? HTTPURLResponse,
			  (200..<300).contains(response.statusCode)
		else {
			let error = try decoder.decode(FailureResponse.self, from: data)
			throw error
		}
		return try decoder.decode(model.self, from: data)
	}
	
	private func defaultHeaders() -> HTTPHeaders {
		[
			"Accept": "application/json",
			"Content-Type": "application/json",
			"X-Webhook-Mode": environment.rawValue
		]
	}
}

struct AuthParams: Decodable {
	let access: String
	let refresh: String
	let expires: Int
}

extension TransactionKind {
	fileprivate var urlPath: QueryBuilder.URLPath {
		switch self {
		case .cashIn: return .cashIn
		case .cashOut: return .cashOut
		}
	}
	
	fileprivate var httpMethod: String {
		switch self {
		case .cashIn, .cashOut: return HTTPMethod.POST
		}
	}
}
