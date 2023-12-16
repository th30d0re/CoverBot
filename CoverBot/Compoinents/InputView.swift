//
//  InputView.swift
//  CoverBot
//
//  Created by Emmanuel Theodore on 5/20/23.
//

import SwiftUI

struct InputView: View {
    @EnvironmentObject var settings: Settings
    @State private var selection = 0
    @State private var showingFilePicker = false
    @State private var selectedPDFURL: URL?
    
    var body: some View {
        VStack {
            Picker(selection: $selection, label: Text("Select a document to view")) {
                Text("Text").tag(0)
                Text("PDF").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            
            if selection == 0 {
                VStack {
                    ExpandingMessageFieldViewModel.ExpandingCustomTextField(placeholder: Text("Résumé"), text: $settings.Résumé, lineLimit: settings.lineLimit)
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .background(Color(.systemFill))
                        .cornerRadius(25)
                        .padding()
                }
                
            } else {
                if let pdfURL = selectedPDFURL {
                  //  CustomPDFView(title: "Selected PDF", displayedPDFURL: pdfURL)
                    Spacer()
                } else {
                    Spacer()
                    Button(action: {
                        showingFilePicker = true
                    }, label: {
                        Text("Select PDF")
                            .frame(minWidth: 300)
                            .foregroundColor(.white)
                            .padding(13)
                            .background(Color(.systemBlue))
                            .cornerRadius(50)
                            .shadow(color: Color("ShadowColor"), radius: 5, x: 0, y: 5)
                    })
                    Spacer()
                }
                
            }
        }
        .sheet(isPresented: $showingFilePicker) {
           // DocumentPicker(filePath: $selectedPDFURL)
        }
    }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView()
            .environmentObject(Settings())
    }
}
