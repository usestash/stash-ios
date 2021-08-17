//
//  PastaDishDetail.swift
//  StashAnalyticsDemo
//
//  Created by Ciprian Redinciuc on 22.07.2021.
//

import SwiftUI
import StashAnalytics

struct PastaDishDetail: View {
    var pastaDish: PastaDish
    @State private var zoomed = false

    var body: some View {
        VStack {
            Spacer(minLength: 0/*@END_MENU_TOKEN@*/)
            Image(pastaDish.imageName)
                .resizable()
                .aspectRatio(contentMode: zoomed ? .fill : .fit)
                .onTapGesture {
                    withAnimation {
                        zoomed.toggle()
                    }
                }
            Spacer(minLength: 0/*@END_MENU_TOKEN@*/)
            if !zoomed {
                HStack(alignment: .center) {
                    Spacer()
                    Label(pastaDish.description, systemImage: "info.circle")
                    Spacer()
                }
                .padding(.all)
                .font(/*@START_MENU_TOKEN@*/.subheadline/*@END_MENU_TOKEN@*/)
                .background(Color.yellow)
                .transition(.move(edge: .bottom))
            }
        }
        .navigationTitle(pastaDish.name)
        .edgesIgnoringSafeArea(.bottom)
        .onAppear(perform: {
            StashAnalytics.main.trackScreenView(screenName: "Pasta Dish Detail")
            StashAnalytics.main.trackSelectContent(content: pastaDish.name)
        })
    }
}

struct PastaDishDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PastaDishDetail(pastaDish: testData[0])
        }
    }
}
