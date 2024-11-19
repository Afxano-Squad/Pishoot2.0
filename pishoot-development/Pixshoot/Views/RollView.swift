import SwiftUI

struct RollView: View {
    @StateObject private var viewModel = AcclerometerViewModel() // ViewModel instance
    let numberOfBars = 15
    @State private var accelerationText: String = "Z-Acceleration: 0.0"
    @State private var isLocked = false  // To track if the position is locked
    
    var body: some View {
        ZStack {
            VStack{
                Text(accelerationText)
                    .font(.title)
            }
            
            HStack {
                Spacer()
                VStack(alignment: .trailing) {
                    ForEach(0..<numberOfBars, id: \.self) { index in
                        Rectangle()
                            .fill(index == calculateDynamicIndex() ? Color.white.opacity(0.5) : Color.white.opacity(0.3))
                            .frame(width: calculateWidth(for: index), height: 10)
                    }
                }
            }
            
            HStack {
                Spacer()
                VStack(alignment: .trailing) {
                    Rectangle()
                        .fill(Color.yellow)
                        .frame(width: 60, height: 10)
                }
            }
        }
        .onAppear {
            viewModel.start()
        }
        .onDisappear {
            viewModel.stop() // Stop receiving accelerometer updates
        }
        .onChange(of: viewModel.accelerationZ) { newAccelerationZ in
            // Print the raw value to debug
            print("Raw Z-Acceleration: \(newAccelerationZ)")
            
            // Update the displayed acceleration text
            accelerationText = String(format: "Z-Acceleration: %.4f", newAccelerationZ)
        }
    }
    
    func calculateWidth(for index: Int) -> CGFloat {
        if index == calculateDynamicIndex() {
            return 60
        } else if abs(index - calculateDynamicIndex()) == 1 {
            return 40
        } else {
            return 20
        }
    }
    
    func calculateDynamicIndex() -> Int {
        let midIndex = numberOfBars / 2
        let scaledZ = Int(viewModel.accelerationZ * 6.5) // Adjust the multiplier for sensitivity as needed
        let adjustedIndex = midIndex + scaledZ
        
        // Ensure the index stays within bounds
        return max(0, min(numberOfBars - 1, adjustedIndex))
    }
}

#Preview {
    RollView()
}
