//
//  LKFeedbackGen.swift
//  LKFeebackGenerator
//
//  Created by Lal Krishna on 12/03/19.
//  Copyright © 2019 Lal Krishna. All rights reserved.
//

import UIKit
import AudioToolbox

public enum FeedbackSupport {
    case none, tapticEngine, haptic
}

public struct LKFeedbackGen {
    
    internal enum TapticSignal {
        case peek, pop, cancelled, tryAgain, failed
        
        private var soundID: SystemSoundID {
            switch self {
            // 'Peek' feedback (weak boom)
            case .peek:
                return 1519
            // 'Pop' feedback (strong boom)
            case .pop:
                return 1520
            // 'Cancelled' feedback (three sequential weak booms)
            case .cancelled:
                return 1521
            // 'Try Again' feedback (week boom then strong boom)
            case .tryAgain:
                return 1102
            // 'Failed' feedback (three sequential strong booms)
            case .failed:
                return 1107
            }
        }
        
        func feedback() {
            AudioServicesPlaySystemSound(soundID)
        }
    }
    
    public enum HapticSignal {
        case selection, light, medium, heavy, success, warn, error, cancelled
        
        internal func feedback() {
            switch self {
            // Type: Selection Feedback
            case .selection:
                selectionFeedback()
            // Type: Impact Feedback
            case .light, .medium, .heavy:
                impactFeedback()
            // Type: Notification Feedback
            case .success, .warn, .error, .cancelled:
                notificationFeedback()
            }
        }
        
        private func notificationFeedback() {
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            switch self {
            case .success:
                generator.notificationOccurred(.success)
            case .warn:
                generator.notificationOccurred(.warning)
            case .error, .cancelled:
                generator.notificationOccurred(.error)
            default:
                fatalError("Should be called for generating success/warn/error/cancelled feedback only")
            }
        }
        
        private func impactFeedback() {
            var feedbackStyle = UIImpactFeedbackGenerator.FeedbackStyle.light
            switch self {
            case .light:
                feedbackStyle = .light
            case .medium:
                feedbackStyle = .medium
            case .heavy:
                feedbackStyle = .heavy
            default:
                fatalError("impactFeedback should be called for light/medium/heavy only.")
            }
            let generator = UIImpactFeedbackGenerator(style: feedbackStyle)
            generator.prepare()
            generator.impactOccurred()
        }
        
        private func selectionFeedback() {
            let generator = UISelectionFeedbackGenerator()
            generator.prepare()
            generator.selectionChanged()
        }
        
        
        internal var asTaptic: TapticSignal {
            switch self {
            case .selection, .light, .medium:
                return .peek
            case .heavy, .success:
                return .pop
            case .warn:
                return .tryAgain
            case .error:
                return .failed
            case .cancelled:
                return .cancelled
            }
        }
    }
    
    
    
    /// Generates feedback on device
    /// - Parameters:
    ///   - signal: Signal type which should be triggered.
    public static func feedback(signal: HapticSignal) {
        guard let feedback = FeedbackManager.shared.feedback else { return }
        switch feedback {
        case .none:
            break
        case .tapticEngine:
            generateTapticFeedback(signal.asTaptic)
        case .haptic:
            generateHapticFeedback(signal)
        }
    }
    
    private static func generateHapticFeedback(_ signal: HapticSignal) {
        signal.feedback()
    }
    
    private static func generateTapticFeedback(_ signal: TapticSignal) {
        signal.feedback()
    }
    
    static func generateDefaultVibration() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
}


class FeedbackManager {
    
    static let shared = FeedbackManager()
    
    var feedback: FeedbackSupport?
    
    private init() {
        feedback = checkFeedbackSupport()
    }
    
    private func checkFeedbackSupport() -> FeedbackSupport? {
        var deviceName = UIDevice.current.deviceName()
        guard deviceName.contains("iPhone") else { return FeedbackSupport.none }
        deviceName = deviceName.replacingOccurrences(of: "iPhone", with: "")
        guard let range = deviceName.range(of: ",") else { return FeedbackSupport.none }
        let sub = deviceName[..<range.lowerBound]
        let version = Int(sub)!
        if version >= 9 {
            return .haptic
        }
        if version >= 8 {
            return .tapticEngine
        }
        return FeedbackSupport.none
    }
    
}

extension UIDevice {
    func deviceName() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
}
