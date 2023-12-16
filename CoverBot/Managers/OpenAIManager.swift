//
//  OpenAIManager.swift
//  CoverBot
//
//  Created by Emmanuel Theodore on 5/10/23.
//

import Foundation
import OpenAISwift

class OpenAIManager: ObservableObject {
    let settings: Settings?
    @Published private(set) var client: OpenAISwift?
    @Published var isLoading = false
    private var authToken = UserDefaults.standard.string(forKey: "apiKey") ?? "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"
    @Published var models = [String]()
    
    // On initialize of the OpenAIManager class, get the messages from Firestore
    init(settings: Settings? = nil) {
        client = OpenAISwift(authToken: authToken)
        self.settings = settings
        print("===> DEBUG: (OAIM.swift): OpenAIManager initalized")
    }
    
    /**
     Sends a text message to OpenAI API and returns the response
     - Parameters:
        - text: The text message to be sent to the API
        - model: The OpenAI model to use for the request
        - maxTokens: The maximum number of tokens to generate in the response
        - completion: A closure that will be called with a Result containing the API's response as a String on success or an Error on failure
     */
    @MainActor func send(jobDiscription: String, résumé: String, model: OpenAIModelType, maxTokens: Int, completion: @escaping (Result<String, Error>) -> Void){
        print("===> DEBUG: (OAIM.swift): sending jobDiscription: \(jobDiscription)")
        print("===> DEBUG: (OAIM.swift): sending résumé: \(résumé)")
        print("===> DEBUG: (OAIM.swift): model:\(model), maxTokens:\(maxTokens)")
        // Make an empty array of chat messages
        var chat: [ChatMessage] = []
        
        // Add the system prompt as the first message
        let systemPrompt = ChatMessage(role: .system, content: settings?.systemPrompt ?? "You are a helpful assistant.")
        print("===> DEBUG: (OAIM.swift): systemPrompt: \(systemPrompt)")
        chat.insert(systemPrompt, at: 0)
        
        // creates two new string variables, formattedJobDescription and formattedResume, by adding double quotes around the jobDiscription and résumé strings and prefixing each with "Job Description: " and "Résumé: ", respectively.
        let formattedJobDescription = "Job Description: \"" + jobDiscription + "\""
        let formattedResume = "Résumé: \"" + résumé + "\""
        let message = formattedJobDescription + formattedResume
        print("===> DEBUG: (OAIM.swift): message:\(message)")
        // Add the user message as the last message
        let userMessage = ChatMessage(role: .user, content: message)
        chat.append(userMessage)
        
        client?.sendChat(with: chat, model: model, maxTokens: maxTokens, completionHandler: { result in
            switch result {
                case .success(let model):
                    DispatchQueue.main.async{
                        let output = model.choices.first?.message.content ?? "Nothing"
                        completion(.success(output))
                        // add number of words used to 'words'
                        let wordArray = message.components(separatedBy: " ")
                        let wordCount = wordArray.count
                        self.settings?.words += wordCount
                        
                    }
                case .failure(let error):
                    DispatchQueue.main.async{
                        completion(.failure(error))
                        print("===> DEBUG: Error sending message to OpenAi")
                    }
            }
        })
    }
}
