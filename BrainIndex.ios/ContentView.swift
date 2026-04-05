//
//  ContentView.swift
//  BrainIndex.ios
//
//  Created by 工藤翔太 on 2026/04/05.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: BrainIndex_iosDocument

    var body: some View {
        TextEditor(text: $document.text)
    }
}

#Preview {
    ContentView(document: .constant(BrainIndex_iosDocument()))
}
