import SwiftUI

struct AcclerometerView: View {
    @ObservedObject var acleroViewModel : AcclerometerViewModel
    let numberOfBars = 15
    @State private var accelerationText: String = "Z-Acceleration: 0.0"
    @Binding var isLocked: Bool

    var body: some View {
        ZStack {
//            VStack {
//                Text(accelerationText)
//                    .font(.title)
//            }

            HStack {
                Spacer()
                VStack(alignment: .trailing) {
                    ForEach(0..<numberOfBars, id: \.self) { index in
                        Rectangle()
                            .fill(index == calculateDynamicIndex() ? Color.yellow : Color.white.opacity(0.3))
                            .frame(width: calculateWidth(for: index), height: 10)
                    }
                }
            }

            HStack {
                Spacer()
                VStack(alignment: .trailing) {
                    Rectangle()
                        .fill(Color.white.opacity(0.5))
                        .frame(width: 60, height: 10)
                }
            }
        }
        .onAppear {
            acleroViewModel.start()
        }
        .onDisappear {
            acleroViewModel.stop()
        }
//        .onChange(of: acleroViewModel.accelerationZ) { _,newAccelerationZ in
//            accelerationText = String(format: "Z-Acceleration: %.4f", newAccelerationZ)
//        }
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

        // Use the locked baseline as an offset if it's set
        let offsetZ = acleroViewModel.lockedBaselineZ ?? 0.0
        let adjustedZ = acleroViewModel.accelerationZ - offsetZ // Adjust by baseline but keep updates live
        let scaledZ = Int(adjustedZ * 6.5)
        let adjustedIndex = midIndex + scaledZ

        // Ensure the index stays within bounds
        return max(0, min(numberOfBars - 1, adjustedIndex))
    }
}
