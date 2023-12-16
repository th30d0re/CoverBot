//
//  CoverLetterView.swift
//  CoverBot
//
//  Created by Emmanuel Theodore on 5/10/23.
//

import SwiftUI

struct CoverLetterView: View {
    @ObservedObject var viewModel: ExpandingMessageFieldViewModel
    @EnvironmentObject var settings: Settings
    var body: some View {
        VStack {
            HStack {
                ExpandingMessageFieldViewModel.ExpandingCustomTextField(placeholder: Text("Cover Letter"), text: $settings.response, lineLimit: 20...25)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        //.background(Color(.systemFill))
        .cornerRadius(25)
        .padding()
        .shadow(color: Color("ShadowColor"), radius: 5, x: 0, y: 5)
        .gesture(
            TapGesture()
                .onEnded { _ in
                    //UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
        )
    //.background(Color(.systemBackground))
    }
}

struct CoverLetterView_Previews: PreviewProvider {
    static var previews: some View {
        CoverLetterView(viewModel: ExpandingMessageFieldViewModel())
            .environmentObject(Settings())
    }
}
