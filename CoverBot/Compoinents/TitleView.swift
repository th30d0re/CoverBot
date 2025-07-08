//
//  TitleView.swift
//  CoverBot
//
//  Created by Emmanuel Theodore on 5/10/23.
//

import SwiftUI

struct TitleView: View {
    @State var name = "CoverBot"
    @State var presentSheet: Bool
    @State private var threadListSheet = false
    @EnvironmentObject var threadStore: ThreadStore
    
    var body: some View {
        HStack {
            Button {
                threadListSheet.toggle()
            } label: {
                Image(systemName: "circle.dashed.inset.filled")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .background(Color("grayColor"))
                    .foregroundColor(Color("TileViewColor"))
                    .clipShape(Circle())
                    .shadow(color: Color("ShadowColor"), radius: 5, x: 0, y: 5)
            }
            .sheet(isPresented: $threadListSheet) {
                ThreadListView()
                    .environmentObject(threadStore)
            }
            Text(name)
                .font(.title).bold()
                //.foregroundColor(Color(UIColor.label))
            
            Spacer()
            
            Button(action: {
                self.presentSheet = true
            }, label: {
                Image(systemName: "gearshape")
                    .padding(10)
                    .background(Color("grayColor"))
                    .foregroundColor(.white)
                    .cornerRadius(50)
                    .shadow(color: Color("ShadowColor"), radius: 5, x: 0, y: 5)
            }).sheet(isPresented: $presentSheet) {
                SettingsView(presentSheet: $presentSheet)
                    .presentationDetents([.height(780)])
                    .presentationDragIndicator(.visible)
            }
        }
        .padding(.horizontal)
    }
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView(presentSheet: false)
            .environmentObject(ThreadStore())
    }
}
