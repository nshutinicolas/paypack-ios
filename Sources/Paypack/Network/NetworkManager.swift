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
	func sendRequest(for transactionKind: TransactionKind, payload: RequestPayload) async throws -> RequestResponse
	func findTransaction(with id: String) async throws -> TransactionResponse
}

typealias HTTPHeaders = [String: String]
final class NetworkManager: NetworkManagerProtocol {
	private let configs: Configs
	private let environment: Environment
	private let session: URLSessionProtocol
	private let decoder: JSONDecoder
	private let encoder: JSONEncoder
	
	private var authKeys: AuthParams?
	private var authKeyTask: Task<Void, Never>?
	private var refreshKeysTask: Task<Void, Never>?
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
		refreshKeysTask?.cancel()
		timer?.invalidate()
	}
	
	func sendRequest(for transactionKind: TransactionKind, payload: RequestPayload) async throws -> RequestResponse {
		guard payload.isValid else {
			throw FailureResponse(message: "Invalid payload content")
		}
		return try await makeTransaction(for: transactionKind, payload: payload)
	}
	
	func findTransaction(with id: String) async throws -> TransactionResponse {
		let authHeader = try await authHeader()
		guard let urlRequest = QueryBuilder.urlRequest(for: .transaction(id: id), method: HTTPMethod.GET, environment: environment, additionalHeaders: authHeader) else {
			throw URLError(.badURL)
		}
		return try await fetch(TransactionResponse.self, for: urlRequest)
	}
	
	private func makeTransaction(for kind: TransactionKind, payload: RequestPayload) async throws -> RequestResponse {
		let authHeader = try await authHeader()
		guard var urlRequest = QueryBuilder.urlRequest(for: kind.urlPath, method: HTTPMethod.POST, additionalHeaders: authHeader) else {
			throw URLError(.badURL)
		}
		let requestBody = try encoder.encode(payload)
		urlRequest.httpBody = requestBody
		
		return try await fetch(RequestResponse.self, for: urlRequest)
	}
	
	private func updateAuthkeys(for configs: Configs) {
		authKeyTask = Task { [weak self] in
			guard let self else { return }
			let authKeys = try? await self.fetchAuthKeys(for: configs)
			self.authKeys = authKeys
			// After updating the configs, start the timer to update the auth keys after every 15 mins
			if timer == nil {
				scheduleTimer()
			}
			self.authKeyTask = nil
		}
	}
	
	@objc
	private func refreshAuthKeysByTimer() {
		guard authKeyTask == nil, let authKeys else { return }
		refreshKeysTask = Task { [weak self] in
			guard let self, let urlRequest = QueryBuilder.urlRequest(for: .refreshToken(token: authKeys.refresh), method: HTTPMethod.GET) else { return }
			let tokens = try? await self.fetch(AuthParams.self, for: urlRequest)
			self.authKeys = tokens
			self.refreshKeysTask = nil
		}
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
	
	private func authHeader() async throws -> HTTPHeaders {
		var additionalHeader: HTTPHeaders = [:]
		if let authKeys {
			additionalHeader["Authorization"] = authKeys.access
		} else {
			let auth = try await fetchAuthKeys(for: configs)
			additionalHeader["Authorization"] = auth.access
			self.authKeys = auth
		}
		return additionalHeader
	}
	
	private func scheduleTimer() {
		// TODO: Fix timer scheduling
		timer = Timer.scheduledTimer(timeInterval: 900, target: self, selector: #selector(refreshAuthKeysByTimer), userInfo: nil, repeats: true)
	}
}

struct AuthParams: Decodable {
	let access: String
	let refresh: String
	let expires: Int
}

extension TransactionKind {
	fileprivate var urlPath: QueryBuilder.Path {
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
