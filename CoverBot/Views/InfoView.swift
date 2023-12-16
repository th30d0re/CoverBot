//
//  infoView.swift
//  CoverBot
//
//  Created by Emmanuel Theodore on 5/10/23.
//

import SwiftUI


struct InfoView: View {
    @Environment(\.dismiss) private var dismiss
    enum ModelType: String, CaseIterable {
        case chatGPT = "ChatGPT"

    }

    @State private var selectedModelType: ModelType = .chatGPT
    
    var modelImage: Image {
        switch selectedModelType {
            case .chatGPT:
                return Image(systemName: "bubble.left")
        }
    }
    
    var body: some View {
        NavigationStack{
            VStack{
                List {
                    switch selectedModelType {
                        case .chatGPT:
                           AccordionItemView(
                               title: "Chat: GPT-4",
                               content: """
                               More capable than any GPT-3.5 model, able to do more complex tasks, and optimized for chat. Will be updated with our latest model iteration.
                               
                               Model Name: gpt-3.5-turbo
                               Max Tokens: 8,192 tokens
                               Training Data: Up to Sep 2021
                               """
                           )
                           AccordionItemView(
                               title: "Chat: GPT-3.5 Turbo 0301",
                               content: """
                               Snapshot of gpt-3.5-turbo from March 1st 2023. Unlike gpt-3.5-turbo, this model will not receive updates, and will only be supported for a three month period ending on June 1st
                               
                               Max Tokens: 4,096 tokens
                               Training Data: Up to Sep 2021
                               """
                           )
                           AccordionItemView(
                               title: "Chat: GPT-3.5 Turbo",
                               content: """
                               Most capable GPT-3.5 model and optimized for chat at 1/10th the cost of text-davinci-003. Will be updated with our latest model iteration.
                               
                               Model Name: gpt-3.5-turbo
                               Max Tokens: 4,096 tokens
                               Training Data: Up to Sep 2021
                               """
                           )
                        
                    }
                }
                Picker(selection: $selectedModelType, label: Text("")) {
                    ForEach(ModelType.allCases, id: \.self) { modelType in
                        Text(modelType.rawValue).tag(modelType)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                Spacer(minLength: 20)
                modelImage
                    .resizable()
                    .frame(width: 50, height: 50)
            }
            //.navigationBarTitle("Models")
            .toolbar{
                ToolbarItem(placement: .confirmationAction){
                    Button("Done"){
                        dismiss()
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
        
        
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}

struct AccordionItemView: View {
    let title: String
    let content: String
    
    @State private var isExpanded = false
    
    var body: some View {
        VStack {
            Button(action: { isExpanded.toggle() }) {
                HStack {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary) // Change text color to system color
                        .shadow(color: Color("ShadowColor"), radius: 2, x: 0, y: 2)
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.headline)
                        .foregroundColor(.primary) // Change icon color to system color
                }
                .padding([.top, .bottom], 6) // Add padding to the content
            }
            
            if isExpanded {
                Text(content)
                    .lineLimit(nil)
            }
        }
        .shadow(color: Color("ShadowColor"), radius: 5, x: 0, y: 5)
    }
}
