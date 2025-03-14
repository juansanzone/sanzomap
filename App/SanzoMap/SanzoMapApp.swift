//
//  SanzoMapApp.swift
//  SanzoMap
//
//  Created by Juan Sanzone on 11/03/2025.
//

import SwiftUI
import MapFeature
import Core

@main
struct SanzoMapApp: App {
    var body: some Scene {
        WindowGroup {
            MapFeature.MainView().onAppear {
                setupLogger()
            }
        }
    }
}

private extension SanzoMapApp {
    func setupLogger() {
        Core.Logger.minimumLogLevel = .debug
    }
}
