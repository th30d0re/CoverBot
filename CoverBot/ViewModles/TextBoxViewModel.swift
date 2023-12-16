//
//  TextBoxViewModel.swift
//  CoverBot
//
//  Created by Emmanuel Theodore on 5/10/23.
//

import Foundation
import SwiftUI

class ExpandingMessageFieldViewModel: ObservableObject {
    /**
        A struct representing a custom text field that expands based on the number of lines of text.
     
        - Parameters:
            - placeholder: A text that is displayed when the text field is empty.
            - text: A binding to the text in the text field.
            - lineLimit: A closed range of integers representing the minimum and maximum number of lines the text field can expand to.
     
        - Returns: A ZStack containing a placeholder text and a TextField view.
    */
    struct ExpandingCustomTextField: View {
        @EnvironmentObject var settings: Settings
        /// Text to be shown when the text field is empty
        var placeholder: Text
        /// The text that the text field will hold
        @Binding var text: String
        /// The range of lines allowed for the text field
        var lineLimit: ClosedRange<Int>
        
        var body: some View {
            ZStack(alignment: .leading){
                if text.isEmpty {
                    if settings.isDyslexic{
                        placeholder
                            .opacity(0.5)
                            .font(.custom("OpenDyslexicThree-Regular", size: CGFloat(settings.openDyslexic3FontSize)))
                    } else {
                        placeholder
                            .opacity(0.5)
                    }
                    
                }
                if settings.isDyslexic {
                    TextField("", text: $text, axis: .vertical)
                        .font(.custom("OpenDyslexicThree-Regular", size: CGFloat(settings.openDyslexic3FontSize)))
                        .lineLimit(lineLimit)
                        .background(GeometryReader { proxy in
                            Color.clear.preference(key: LineLimitKey.self, value: [CGFloat(proxy.size.height)])
                        })
                } else {
                    TextField("", text: $text, axis: .vertical)
                        .lineLimit(lineLimit)
                        .background(GeometryReader { proxy in
                            Color.clear.preference(key: LineLimitKey.self, value: [CGFloat(proxy.size.height)])
                        })
                }
            }
        }
    }

    /**
        A struct representing the preference key for the line limit of the custom text field.
        It holds an array of CGFloats representing the heights of the text field.
     
        - Parameters:
            - Value: An array of CGFloats representing the heights of the text field.
            - defaultValue: An empty array of CGFloats.
     
        - Returns: A preference key that can be used to track the line limit of a text field.
    */
    struct LineLimitKey: PreferenceKey {
        typealias Value = Array<CGFloat>
        static var defaultValue: Value = []

        static func reduce(value: inout Value, nextValue: () -> Value) {
            value.append(contentsOf: nextValue())
        }
    }
}

