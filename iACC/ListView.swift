//	
// Copyright © Essential Developer. All rights reserved.
//

import SwiftUI
//7:16

struct ListView: View {
    @State private var items = [ItemViewModel]()
    @State private var error: Error?
    private var isShowingError: Binding<Bool> {
        Binding (
            get: { error != nil },
            set: {_ in error = nil }
        )
    }
    
    let service: ItemsService
    
    var body: some View {
        List {
            
        }
        .refreshable { await refresh() }
        .task {
            if items.isEmpty {
                await refresh()
            }
        }
        .alert("Error", isPresented: isShowingError, actions: {}) {
            if let message = error?.localizedDescription {
                Text(message)
            }
        }
    }
    
    private func refresh() async {
        service.loadItems(completion: handleAPIResult)
    }
    
    private func handleAPIResult(_ result: Result<[ItemViewModel], Error>) {
        switch result {
        case let .success(items):
            self.items = items
        case let .failure(error):
            self.error = error
        }
    }
}
