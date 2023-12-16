//
//  TextBoxView.swift
//  CoverBot
//
//  Created by Emmanuel Theodore on 5/10/23.
//

import SwiftUI
import OpenAISwift

struct TextBoxView: View {
    @ObservedObject var viewModel: ExpandingMessageFieldViewModel
    @EnvironmentObject var settings: Settings
    
    @State var models = [String]()
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @State var isLoading = false
    @State private var isSpinning = false

    @Binding var selection: Int
    
    var body: some View {
        VStack {
            VStack {
                if !settings.isLoading { // need to add '!' before compiling
                    VStack {
                        HStack {
                            ExpandingMessageFieldViewModel.ExpandingCustomTextField(placeholder: Text("Job Discription"), text: $settings.JobDiscription, lineLimit: settings.lineLimit)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(Color(.systemFill))
                    .cornerRadius(25)
                    .padding()
                    .alert(isPresented: $showError) {
                        Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")) {
                          self.showError = false
                        })
                    }
                    .shadow(color: Color("ShadowColor"), radius: 5, x: 0, y: 5)
               // .background(Color(.systemBackground))
                    
                    Spacer(minLength: 20)
                    
                    VStack {
                        HStack {
                            InputView()
                        }
                    }
                    .padding()
                    .alert(isPresented: $showError) {
                        Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")) {
                          self.showError = false
                        })
                    }
                    .shadow(color: Color("ShadowColor"), radius: 5, x: 0, y: 5)
               // .background(Color(.systemBackground))
                } else {
                    Spacer()
                    Button {
                       
                    } label: {
                        Image(systemName: "circle.dashed.inset.filled")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                            .background(Color("grayColor"))
                            .foregroundColor(Color("TileViewColor"))
                            .clipShape(Circle())
                            .shadow(color: Color("ShadowColor"), radius: 5, x: 0, y: 5)
                    }
                    .rotationEffect(.degrees(isSpinning ? 2880 : 0))
                    .onAppear {
                        withAnimation(.linear(duration: 30)) {
                            self.isSpinning = true
                        }
                    }
                    Spacer()
                }
            }
            Spacer()
            Button(action: {
                //TO:DO
                if !isLoading {
                    send()
                }
            }, label: {
                if isLoading {
                    LoadingView()
                        .scaleEffect(0.2)
                        .frame(minWidth: 0, maxWidth: 300, alignment: .center)
                        .frame(height: 30)
                        .shadow(color: Color("ShadowColor"), radius: 5, x: 0, y: 5)
                        .padding(13)
                        .background(.regularMaterial)
                        .cornerRadius(50)
                } else {
                    Image(systemName: "paperplane.fill")
                        .frame(minWidth: 300)
                        .foregroundColor(.white)
                        .padding(13)
                        .background(Color(.systemBlue))
                        .cornerRadius(50)
                        .shadow(color: Color("ShadowColor"), radius: 5, x: 0, y: 5)
                }
            })
        }
        .gesture(
            TapGesture()
                .onEnded { _ in
                   // UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
        )
    }
    
    func send(){
        isLoading = true
        settings.isLoading = true
        let openAIManager = OpenAIManager(settings: settings)
        DispatchQueue.main.async {
            openAIManager.send(jobDiscription: settings.JobDiscription, résumé: settings.Résumé, model: settings.selectedModelType, maxTokens: settings.maxTokens) { response in
                isLoading = false
                settings.isLoading = false
                self.selection = 1
                if case .success(let responseString) = response {
                    DispatchQueue.main.async {
                        // Send the responce to memery
                        self.settings.response = responseString
                        
                        // add number of words used to 'words'
                        let wordArray = responseString.components(separatedBy: " ")
                        let wordCount = wordArray.count
                        self.settings.words += wordCount
                    }
                }
                if case .failure(let error) = response {
                    DispatchQueue.main.async {
                        self.showError = true
                        self.errorMessage = "Error Sending message to OpenAI \n" + error.localizedDescription
                    }
                }
            }
        }
    }
}

struct TextBoxView_Previews: PreviewProvider {
    static var previews: some View {
        TextBoxView(viewModel: ExpandingMessageFieldViewModel(), selection: .constant(1))
            .environmentObject(Settings())
    }
}
