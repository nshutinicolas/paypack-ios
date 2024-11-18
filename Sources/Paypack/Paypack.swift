// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public protocol TransactionActionProtocol {
	func cashInRequest(_ payload: TransactionPayload) async throws -> TransactionResponse
	func cashInRequest(_ payload: TransactionPayload, completion: @escaping (Result<TransactionResponse, Error>) -> Void)
	func cashOutRequest(_ payload: TransactionPayload) async throws -> TransactionResponse
	func cashOutRequest(_ payload: TransactionPayload, completion: @escaping (Result<TransactionResponse, Error>) -> Void)
}

public final class Paypack: TransactionActionProtocol {
	let configs: Configs
	private var cashInTask: Task<Void, Never>?
	private var cashOutTask: Task<Void, Never>?
	private let networkManager: NetworkManagerProtocol
	
	public init(configs: Configs, environment: Environment = .dev) {
		self.configs = configs
		self.networkManager = NetworkManager(configs: configs, environment: environment)
	}
	
	deinit {
		cashInTask?.cancel()
		cashOutTask?.cancel()
	}
	
	public func cashInRequest(_ payload: TransactionPayload) async throws -> TransactionResponse {
		try await networkManager.sendRequest(for: .cashIn, payload: payload)
	}
	
	public func cashInRequest(_ payload: TransactionPayload, completion: @escaping (Result<TransactionResponse, Error>) -> Void) {
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
	
	public func cashOutRequest(_ payload: TransactionPayload) async throws -> TransactionResponse {
		try await networkManager.sendRequest(for: .cashOut, payload: payload)
	}
	
	public func cashOutRequest(_ payload: TransactionPayload, completion: @escaping (Result<TransactionResponse, Error>) -> Void) {
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
}
