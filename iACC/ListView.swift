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
        List(items, id: \.title) { item in
            
            Button {
                item.select()
            } label: {
                VStack(alignment: .leading) {
                    Text(item.title)
                    Text(item.subTitle)
                        .font(.caption)
                }
            }

        }
        .listStyle(.plain)
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
        do {
            self.items = try await service.loadItems()
        } catch {
            self.error = error
        }
    }
}
