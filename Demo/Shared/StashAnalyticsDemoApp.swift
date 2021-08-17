//
//  StashAnalyticsDemoApp.swift
//  Shared
//
//  Created by Ciprian Redinciuc on 18.07.2021.
//

import SwiftUI
import StashAnalytics

@main
struct StashAnalyticsDemoApp: App {
    init() {
        StashAnalytics.initialize(apiKey: "C6e7HBMHVkPJBqGjoaaKhoH1zs4H8hXUtkKp",
                                  applicationIdentifier: "gL14MModpZgxWRGcQQ21zjax")
    }

    var body: some Scene {
        WindowGroup {
            PastaDishesList()
        }
    }
}
