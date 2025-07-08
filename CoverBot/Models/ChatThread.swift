import Foundation
import SwiftUI

struct ThreadMessage: Identifiable {
    let id = UUID()
    var text: String
    var isUser: Bool
}

class ChatThread: ObservableObject, Identifiable {
    let id = UUID()
    @Published var title: String
    @Published var messages: [ThreadMessage]
    
    init(title: String, messages: [ThreadMessage] = []) {
        self.title = title
        self.messages = messages
    }
}

class ThreadStore: ObservableObject {
    @Published var threads: [ChatThread] = []
    
    func addThread(title: String) {
        let thread = ChatThread(title: title)
        threads.append(thread)
    }
}
