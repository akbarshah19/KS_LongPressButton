//
//  ContentView.swift
//  KS_LongPressButtpn
//
//  Created by Akbarshah Jumanazarov on 3/21/24.
//

import SwiftUI

struct ContentView: View {
    @State private var count: Int = 0
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 45) {
                Text("\(count)")
                    .font(.largeTitle.bold())
                
                HoldDownButton(
                    text: "Hold to increase",
                    duration: 2,
                    background: .black,
                    loadingTint: .white.opacity(0.3)
                ) {
                    count += 1
                }
                .foregroundStyle(.white)
            }
            .padding()
            .navigationTitle("Hold Down Button")
        }
    }
}

#Preview {
    ContentView()
}
