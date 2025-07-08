//
//  ContentView.swift
//  CoverBot
//
//  Created by Emmanuel Theodore on 5/10/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var settings: Settings
    @State var presentSheet: Bool
    @State private var selection = 0
    var body: some View {
        VStack {
           TitleView(presentSheet: presentSheet)
            VStack {
                Picker(selection: $selection, label: Text("Select a document to view")) {
                    Text("Job Description and Résumé").tag(0)
                    Text("Cover Letter").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                
                if selection == 0 {
                    TextBoxView(viewModel: ExpandingMessageFieldViewModel(), selection: $selection)
                    
                } else {
                    CoverLetterView(viewModel: ExpandingMessageFieldViewModel())
                }
            }
            .padding()
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(presentSheet: false)
            .environmentObject(Settings())
            .environmentObject(ThreadStore())
    }
}
