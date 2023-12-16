//
//  SettingsView.swift
//  CoverBot
//
//  Created by Emmanuel Theodore on 5/10/23.
//

import SwiftUI
import Combine
import OpenAISwift


struct SettingsView: View {
    @EnvironmentObject var settings: Settings
    @Environment(\.dismiss) var dismiss
    
    @State var alertTitle = "alertTitle"
    @State var alertMessage = "alertMessage"
    @State var showingAlert = false
    @State private var apiKey: String = ""
    
    @Binding var presentSheet: Bool
    
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section {
                        HStack {
                            TextField("API Key", text: $apiKey)
                                .font(settings.isDyslexic ? .custom("OpenDyslexicThree-Regular", size: 12) : .subheadline)
                                .padding(.horizontal)
                                .padding(.vertical, 10)
                                .background(Color(.systemFill))
                                .cornerRadius(15)
                                .padding()
                            Button(action: {
                                // Save the API key to UserDefaults or somewhere else here
                                UserDefaults.standard.set(self.apiKey, forKey: "apiKey")
                            }) {
                                Image(systemName: "square.and.arrow.down.fill")
                                Text("save")
                                    .font(.subheadline)
                            }
                        }
                    }  header: {
                        Text("Enter OpenAI API Key to use CoverBot")
                            .font(settings.isDyslexic ? .custom("OpenDyslexicThree-Regular", size: 12) : .subheadline)
                    } footer: {
                        Button(action: {
                            // Open the URL in the user's default browser
                            if let url = URL(string: "https://beta.openai.com/account/api-keys") {
                                //UIApplication.shared.open(url)
                            }
                        }, label: {
                            Text("Get an API key")
                                .font(settings.isDyslexic ? .custom("OpenDyslexicThree-Regular", size: 12) : .subheadline)
                        })

                    }
                    Section {
                        Toggle("OpenDyslexic3 Font Support", isOn: $settings.isDyslexic)
                            .font(.custom("OpenDyslexicThree-Regular", size: CGFloat(settings.openDyslexic3FontSize)))
                            .shadow(color: Color("ShadowColor"), radius: 2, x: 0, y: 2)
                        if settings.isDyslexic {
                            Picker(selection: $settings.openDyslexic3FontSize, label: Text("OpenDyslexic3 Font Size") .font(.custom("OpenDyslexicThree-Regular", size: CGFloat(settings.openDyslexic3FontSize)))) {
                                ForEach(7...20, id: \.self) {
                                    Text("\($0)").tag($0)
                                }
                            }.shadow(color: Color("ShadowColor"), radius: 5, x: 0, y: 5)
                        }
                    } footer: {
                        Text("Font Settings")
                            .font(settings.isDyslexic ? .custom("OpenDyslexicThree-Regular", size: 12) : .subheadline)

                    }.shadow(color: Color("ShadowColor"), radius: 5, x: 0, y: 5)

                    Section {
                        Picker(selection: $settings.maxTokens, label: ticketView()) {
                            ForEach(1...7, id: \.self) {
                                Text("\($0 * 100)").tag($0 * 100)
                            }
                        }
                    } footer: {
                        Text("The max ammount of tokens per responce")
                            .font(settings.isDyslexic ? .custom("OpenDyslexicThree-Regular", size: 12) : .subheadline)
                    }.shadow(color: Color("ShadowColor"), radius: 5, x: 0, y: 5)
                    
                    Section {
                        Text("Total words used: \(settings.words)")
                            .font(settings.isDyslexic ? .custom("OpenDyslexicThree-Regular", size: CGFloat(settings.openDyslexic3FontSize)) : .system(size: 17))
                    } footer: {
                        Text("The number of words you've sent and recived")
                            .font(settings.isDyslexic ? .custom("OpenDyslexicThree-Regular", size: 12) : .subheadline)
                    }.shadow(color: Color("ShadowColor"), radius: 5, x: 0, y: 5)
                
                    Section {
                        Picker(selection: $settings.selectedModel, label: modelView()) {
                            Group{
                                HStack{
                                    Text("ChatGPT4 Models")
                                    Image(systemName: "bubble.left")
                                }
                                Text("gpt-4").tag("gpt-4")
                                //Text("gpt-4-32k").tag("gpt-4-32k") Not working yet
                            }
                            Group{
                                HStack{
                                    Text("ChatGPT3 Models")
                                    Image(systemName: "bubble.left")
                                }
                                Text("gpt-3.5-turbo").tag("gpt-3.5-turbo")
                                Text("gpt-3.5-turbo-0301").tag("gpt-3.5-turbo-0301")
                            }
                        }
                    } footer: {
                        HStack{
                            Text("Choose which Model you want to use")
                                .font(settings.isDyslexic ? .custom("OpenDyslexicThree-Regular", size: 12) : .subheadline)
                            NavigationLink(destination: InfoView()) {
                                        Image(systemName: "info.circle")
                            }
                        }
                    }
                }
                #if os(iOS) && targetEnvironment(macCatalyst)
                Text("Created by Emmanuel Theodore 🧑🏾‍💻")
                    .font(settings.isDyslexic ? .custom("OpenDyslexicThree-Regular", size: 12) : .subheadline)
                    Spacer()
                #endif
                Text("Created by Emmanuel Theodore 🧑🏾‍💻")
                    .font(settings.isDyslexic ? .custom("OpenDyslexicThree-Regular", size: 12) : .subheadline)
            }
            .navigationTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(presentSheet: .constant(true))
            .environmentObject(Settings())
    }
}


// MARK: Extracted Views

struct modelView: View {
    @EnvironmentObject var settings: Settings

    var body: some View {
        HStack {
            Text("Model")
                .font(settings.isDyslexic ? .custom("OpenDyslexicThree-Regular", size: CGFloat(settings.openDyslexic3FontSize)) : .system(size: 17))

            Image(systemName: "cpu")
        }
    }
}

struct ticketView: View {
    @EnvironmentObject var settings: Settings

    var body: some View {
        HStack {
            Text("Max Tokens")
                .font(settings.isDyslexic ? .custom("OpenDyslexicThree-Regular", size: CGFloat(settings.openDyslexic3FontSize)) : .system(size: 17))

            Image(systemName: "ticket")
        }
    }
}

struct lineLimitView: View {
    @EnvironmentObject var settings: Settings

    var body: some View {
        HStack {
            Text("TextBox Line Limit")
                .font(settings.isDyslexic ? .custom("OpenDyslexicThree-Regular", size: CGFloat(settings.openDyslexic3FontSize)) : .system(size: 17))

            Image(systemName: "arrow.up.and.down.text.horizontal")
        }
    }
}
