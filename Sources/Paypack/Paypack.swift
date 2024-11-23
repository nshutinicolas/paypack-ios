// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public protocol TransactionActionProtocol {
	func cashInRequest(_ payload: RequestPayload) async throws -> RequestResponse
	func cashInRequest(_ payload: RequestPayload, completion: @escaping (Result<RequestResponse, Error>) -> Void)
	func cashOutRequest(_ payload: RequestPayload) async throws -> RequestResponse
	func cashOutRequest(_ payload: RequestPayload, completion: @escaping (Result<RequestResponse, Error>) -> Void)
	func transaction(for transactionId: String) async throws -> TransactionResponse
	func transaction(for transactionId: String, completion: @escaping (Result<TransactionResponse, Error>) -> Void)
}

public final class Paypack: TransactionActionProtocol {
	let configs: Configs
	private var cashInTask: Task<Void, Never>?
	private var cashOutTask: Task<Void, Never>?
	private var transactionTask: Task<Void, Never>?
	private let networkManager: NetworkManagerProtocol
	
	public init(configs: Configs, environment: Environment = .dev) {
		self.configs = configs
		self.networkManager = NetworkManager(configs: configs, environment: environment)
	}
	
	deinit {
		cashInTask?.cancel()
		cashOutTask?.cancel()
		transactionTask?.cancel()
	}
	
	public func cashInRequest(_ payload: RequestPayload) async throws -> RequestResponse {
		try await networkManager.sendRequest(for: .cashIn, payload: payload)
	}
	
	public func cashInRequest(_ payload: RequestPayload, completion: @escaping (Result<RequestResponse, Error>) -> Void) {
		cashInTask = Task { [weak self] in
			guard let self else { return }
			do {
				let response = try await networkManager.sendRequest(for: .cashIn, payload: payload)
				completion(.success(response))
			} catch {
				completion(.failure(error))
			}
			self.cashInTask = nil
		}
	}
	
	public func cashOutRequest(_ payload: RequestPayload) async throws -> RequestResponse {
		try await networkManager.sendRequest(for: .cashOut, payload: payload)
	}
	
	public func cashOutRequest(_ payload: RequestPayload, completion: @escaping (Result<RequestResponse, Error>) -> Void) {
		cashOutTask = Task { [weak self] in
			guard let self else { return }
			do {
				let response = try await networkManager.sendRequest(for: .cashOut, payload: payload)
				completion(.success(response))
			} catch {
				completion(.failure(error))
			}
			self.cashOutTask = nil
		}
	}
	
	public func transaction(for transactionId: String) async throws -> TransactionResponse {
		try await networkManager.findTransaction(with: transactionId)
	}
	
	public func transaction(for transactionId: String, completion: @escaping (Result<TransactionResponse, Error>) -> Void) {
		transactionTask = Task { [weak self] in
			guard let self else { return }
			do {
				let response = try await self.networkManager.findTransaction(with: transactionId)
				completion(.success(response))
			} catch {
				completion(.failure(error))
			}
			self.transactionTask = nil
		}
	}
}
