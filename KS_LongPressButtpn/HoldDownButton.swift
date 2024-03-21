//
//  HoldDownButton.swift
//  KS_LongPressButtpn
//
//  Created by Akbarshah Jumanazarov on 3/21/24.
//

import SwiftUI

struct HoldDownButton: View {
    var text: String
    var duration: CGFloat = 1
    var paddingVertical: CGFloat = 12
    var paddingHorizonal: CGFloat = 25
    var scale: CGFloat = 0.95
    var background: Color
    var loadingTint: Color
    var shape: AnyShape = .init(.capsule)
    var action: () -> ()
    
    @State private var timer = Timer.publish(every: 0.01, on: .current, in: .common).autoconnect()
    @State private var timerCount: CGFloat = 0
    @State private var progress: CGFloat = 0
    
    @State private var isHolding = false
    @State private var isComplete = false
    
    var body: some View {
        Text(text)
            .padding(.vertical, paddingVertical)
            .padding(.horizontal, paddingHorizonal)
            .background {
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(background)
                    
                    GeometryReader {
                        let size = $0.size
                        
                        if !isComplete {
                            Rectangle()
                                .fill(loadingTint)
                                .frame(width: size.width * progress)
                                .transition(.opacity)
                        }
                    }
                }
            }
            .clipShape(shape)
            .contentShape(shape)
            .scaleEffect(isHolding ? scale : 1)
            .animation(.snappy, value: isHolding)
            .gesture(longPressGesture)
            .simultaneousGesture(dragGesture)
            .onReceive(timer, perform: { _ in
                if isHolding && progress != 1 {
                    timerCount += 0.01
                    progress = max(min(timerCount/duration, 1), 0)
                }
            })
            .onAppear(perform: cancelTimer)
    }
    
    var dragGesture: some Gesture {
        DragGesture()
            .onEnded { _ in
                guard !isComplete else { return }
                cancelTimer()
                withAnimation(.snappy) {
                    reset()
                }
            }
    }
    
    var longPressGesture: some Gesture {
        LongPressGesture(minimumDuration: duration)
            .onChanged {
                isComplete = false
                reset()
    
                isHolding = $0
                addTimer()
            }.onEnded { status in
                isHolding = false
                cancelTimer()
                withAnimation(.easeInOut(duration: 0.2)) {
                    isComplete = status
                }
                
                action()
            }
            
    }
    
    private func addTimer() {
        timer = Timer.publish(every: 0.01, on: .current, in: .common).autoconnect()
    }
    
    private func cancelTimer() {
        timer.upstream.connect().cancel()
    }
    
    private func reset() {
        isHolding = false
        progress = 0
        timerCount = 0
    }
}

#Preview {
    ContentView()
}
