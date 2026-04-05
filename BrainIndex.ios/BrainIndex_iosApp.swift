//
//  BrainIndex_iosApp.swift
//  BrainIndex.ios
//
//  Created by 工藤翔太 on 2026/04/05.
//

import SwiftUI

@main
struct BrainIndex_iosApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: BrainIndex_iosDocument()) { file in
            ContentView(document: file.$document)
        }
    }
}
