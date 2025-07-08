import SwiftUI

struct ThreadView: View {
    @ObservedObject var thread: ChatThread
    @EnvironmentObject var settings: Settings
    @StateObject private var manager = OpenAIManager()
    @State private var messageText = ""

    var body: some View {
        VStack {
            List(thread.messages) { msg in
                HStack {
                    if msg.isUser {
                        Spacer()
                        Text(msg.text)
                            .padding(8)
                            .background(Color.accentColor.opacity(0.7))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    } else {
                        Text(msg.text)
                            .padding(8)
                            .background(Color(.systemGray5))
                            .cornerRadius(8)
                        Spacer()
                    }
                }
                .listRowSeparator(.hidden)
            }
            HStack {
                TextField("Message", text: $messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Send") { send() }
                    .disabled(messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding()
        }
        .navigationTitle(thread.title)
    }

    private func send() {
        let text = messageText
        messageText = ""
        let userMsg = ThreadMessage(text: text, isUser: true)
        thread.messages.append(userMsg)
        manager.sendChat(messages: thread.messages, model: settings.selectedModelType, maxTokens: settings.maxTokens) { result in
            switch result {
            case .success(let response):
                let botMsg = ThreadMessage(text: response, isUser: false)
                DispatchQueue.main.async { thread.messages.append(botMsg) }
            case .failure(let error):
                let errMsg = ThreadMessage(text: "Error: \(error.localizedDescription)", isUser: false)
                DispatchQueue.main.async { thread.messages.append(errMsg) }
            }
        }
    }
}

struct ThreadView_Previews: PreviewProvider {
    static var previews: some View {
        let store = ThreadStore()
        store.addThread(title: "Example")
        return NavigationStack { ThreadView(thread: store.threads[0]) }
            .environmentObject(store)
            .environmentObject(Settings())
    }
}
