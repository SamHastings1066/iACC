//	
// Copyright © Essential Developer. All rights reserved.
//

protocol ItemsService {
    func loadItems(completion: @escaping (Result<[ItemViewModel], any Error>) -> Void)
}

extension ItemsService{
    func loadItems() async throws -> [ItemViewModel] {
        try await withCheckedThrowingContinuation { continuation in
            loadItems { result in
                switch result {
                case let .success(items):
                    continuation.resume(returning: items)
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
