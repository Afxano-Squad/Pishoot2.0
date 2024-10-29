import UIKit

class HapticFeedback {
    static let generator = UINotificationFeedbackGenerator()

    static func success() {
        // Prepare the generator for feedback
        generator.prepare()
        // Trigger success feedback
        generator.notificationOccurred(.success)
    }

    static func warning() {
        generator.prepare()
        generator.notificationOccurred(.warning)
    }

    static func error() {
        generator.prepare()
        generator.notificationOccurred(.error)
    }
}
