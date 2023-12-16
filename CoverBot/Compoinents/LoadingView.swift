//
//  LoadingView.swift
//  CoverBot
//
//  Created by Emmanuel Theodore on 5/10/23.
//

import SwiftUI


struct DotView: View {
    @State var delay: Double = 0
    @State var scale: CGFloat = 0.5
    var body: some View {
        Circle()
            .frame(width: 70, height: 70)
            .scaleEffect(scale)
            .foregroundColor(Color.primary.opacity(0.5)) // Set color
            .animation(Animation.easeInOut(duration: 0.6).repeatForever().delay(delay))
            .onAppear {
                withAnimation {
                    self.scale = 1
                }
            }
    }
}

struct LoadingView: View {
    var body: some View {
        HStack {
            DotView()
            DotView(delay: 0.2)
            DotView(delay: 0.4)
        }
        .padding(.zero)
    }
}


struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoadingView()
                .colorScheme(.light)
            LoadingView()
                .preferredColorScheme(.dark)
        }
    }
}

