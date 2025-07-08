import SwiftUI

struct ThreadListView: View {
    @EnvironmentObject var threadStore: ThreadStore
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                ForEach(threadStore.threads) { thread in
                    NavigationLink(destination: ThreadView(thread: thread)) {
                        Text(thread.title)
                    }
                }
            }
            .navigationTitle("Threads")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: addThread) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }

    private func addThread() {
        let title = "Thread \(threadStore.threads.count + 1)"
        threadStore.addThread(title: title)
    }
}

struct ThreadListView_Previews: PreviewProvider {
    static var previews: some View {
        ThreadListView()
            .environmentObject(ThreadStore())
    }
}
