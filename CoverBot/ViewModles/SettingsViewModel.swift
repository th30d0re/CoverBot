//
//  SettingsViewModel.swift
//  CoverBot
//
//  Created by Emmanuel Theodore on 5/10/23.
//

import SwiftUI
import OpenAISwift

@MainActor class Settings: ObservableObject {
    /**
    A flag indicating whether the app is loading.
     */
    @AppStorage("isLoading", store: UserDefaults.standard) var isLoading: Bool = false
    
    /**
    A flag indicating whether the user has a PDF saved.
     */
    @AppStorage("hasPDF", store: UserDefaults.standard) var hasPDF: Bool = false
    
    /**
     A String containing the Résumé.
     */
    @AppStorage("Résumé", store: UserDefaults.standard) var Résumé: String = ""
    
    /**
     A String containing the JobDiscription.
     */
    @AppStorage("JobDiscription", store: UserDefaults.standard) var JobDiscription: String = ""
    
    /**
     A String containing the responce from openAI.
     */
    @AppStorage("response", store: UserDefaults.standard) var response: String = ""
    
    /**
     A number repesenting how many words the user has used.
     */
    @AppStorage("words", store: UserDefaults.standard) var words: Int = 0
    
    /**
     A published variable that holds the user's desired system prompt for Turbo modles.
     */
    @AppStorage("systemPrompt", store: UserDefaults.standard) var systemPrompt: String = "You are a helpful assistant Named CoverBot that takes a resume and a job discription and reutns a coverletter."
    
    /**
    A flag indicating whether dyslexic mode is enabled.

    This value is stored in the `UserDefaults` object under the key "isDyslexic".
    The default value is `false`.
    */
    @AppStorage("isDyslexic", store: UserDefaults.standard) var isDyslexic: Bool = false
    
    /**
    The font size for the OpenDyslexic3 font.

    This value is stored in the `UserDefaults` object under the key "openDyslexic3FontSize".
    The default value is `14`.
    */
    @AppStorage("openDyslexic3FontSize", store: UserDefaults.standard) var openDyslexic3FontSize: Int = 14
    
    /**
    The maximum number of tokens that the model should generate.

    This value is stored in the `UserDefaults` object under the key "maxTokens".
    The default value is `500`.
    */
    @AppStorage("maxTokens", store: UserDefaults.standard) var maxTokens: Int = 500
    
    /**
    The lower bound of the range of lines that should be displayed.

    This value is stored in the `UserDefaults` object under the key "lineLimitLower".
    The default value is `1`.
    */
    @AppStorage("lineLimitLower") var lineLimitLower = 10

    /**
    The upper bound of the range of lines that should be displayed.

    This value is stored in the `UserDefaults` object under the key "lineLimitUpper".
    The default value is `10`.
    */
    @AppStorage("lineLimitUpper") var lineLimitUpper = 10
    
    /**
    A range representing the number of lines that should be displayed.

    The lower bound of the range is stored in `lineLimitLower` and the upper bound is stored in `lineLimitUpper`.
    */
    var lineLimit: ClosedRange<Int> {
      get {
          return lineLimitLower...lineLimitUpper
      }
      set {
          lineLimitLower = newValue.lowerBound
          lineLimitUpper = newValue.upperBound
      }
    }
    
    /**
    The selected OpenAI model to use for text generation.

    This value is stored in the `UserDefaults` object under the key "selectedModel".
    The default value is "text-davinci-003".
    */
    @AppStorage("selectedModel", store: UserDefaults.standard) var selectedModel: String = "gpt-3.5-turbo"
    
    /**
    The `selectedModelType` computed property is used to determine the type of OpenAI model to use based on the value of the `selectedModel` property.

    - Returns: The `OpenAIModelType` enum associated with the selected model.

    - Note: The `OpenAIModelType` enum can take on the following values:
    - `OpenAIModelType.gpt3(.davinci)`
    - `OpenAIModelType.gpt3(.curie)`
    - `OpenAIModelType.gpt3(.babbage)`
    - `OpenAIModelType.gpt3(.ada)`
    - `OpenAIModelType.feature(.davinci)`
    - `OpenAIModelType.codex(.davinci)`
    - `OpenAIModelType.codex(.cushman)`
    - `OpenAIModelType.gpt3(.curie)` (default)

    - Note: The `selectedModel` property must be one of the following values:
    - "text-davinci-003"
    - "text-curie-001"
    - "text-babbage-001"
    - "text-ada-001"
    - "text-davinci-edit-001"
    - "code-davinci-002"
    - "code-cushman-001"
    */

    var selectedModelType: OpenAIModelType {
       switch selectedModel {
           case "text-davinci-003":
               return OpenAIModelType.gpt3_5(.davinci)
           case "text-davinci-002":
               return OpenAIModelType.gpt3_5(.davinci002)
           case "davinci":
               return OpenAIModelType.gpt3(.davinci)
           case "text-curie-001":
               return OpenAIModelType.gpt3(.curie)
           case "text-babbage-001":
               return OpenAIModelType.gpt3(.babbage)
           case "text-ada-001":
               return OpenAIModelType.gpt3(.ada)
           case "text-davinci-edit-001":
               return OpenAIModelType.feature(.davinci)
           case "code-davinci-002":
               return OpenAIModelType.codex(.davinci)
           case "code-cushman-001":
               return OpenAIModelType.codex(.cushman)
           case "gpt-3.5-turbo":
               return OpenAIModelType.chat(.chatgpt)
           case "gpt-3.5-turbo-0301":
               return OpenAIModelType.chat(.chatgpt0301)
           case "gpt-4":
               return OpenAIModelType.chat(.chatgpt4)
           case "gpt-4-32k":
               return OpenAIModelType.chat(.chatgpt432k)
           default:
               return OpenAIModelType.gpt3(.davinci)
       }
    }
    
    var computeIsChatGPT: Bool {
        selectedModel == "gpt-3.5-turbo-0301" || selectedModel == "gpt-3.5-turbo"  || selectedModel == "gpt-4-32k" || selectedModel == "gpt-4"
    }
}
