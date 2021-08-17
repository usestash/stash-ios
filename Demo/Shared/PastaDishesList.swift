//
//  ContentView.swift
//  Shared
//
//  Created by Ciprian Redinciuc on 18.07.2021.
//

import SwiftUI
import StashAnalytics

struct PastaDishesList: View {
    var pastaDishes: [PastaDish] = testData

    var body: some View {
        NavigationView {
            List(pastaDishes) { pastaDish in
                PastaDishCell(pastaDish: pastaDish)
            }
            .navigationTitle("Pasta dishes")
        }
        .onAppear(perform: {
            StashAnalytics.main.trackScreenView(screenName: "Pasta Dishes")
        })
    }
}

struct PastaDishCell: View {
    var pastaDish: PastaDish

    var body: some View {
        NavigationLink(destination: PastaDishDetail(pastaDish: pastaDish)) {
            Image(pastaDish.thumbnailName)
                .resizable()
                .scaledToFill()
                .frame(width: 44, height: 44, alignment: .center/*@END_MENU_TOKEN@*/)
                .clipped()
                .cornerRadius(5.0)
            VStack(alignment: .leading) {
                Text(pastaDish.name)
                Text(pastaDish.region)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PastaDishesList(pastaDishes: testData)
    }
}
