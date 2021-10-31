import Foundation


extension Double {
    func asString(style: DateComponentsFormatter.UnitsStyle) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.nanosecond]
        formatter.unitsStyle = style
        guard let formattedString = formatter.string(from: self) else { return "" }
        return formattedString
    }
    
    func timeString(nanoseconds: Double) -> String {
        
        let hour = Int(nanoseconds) / 360000
        let minute = Int(nanoseconds) / 60000 % 60
        let second = Int(nanoseconds) / 60 % 60
        
        if hour == 0 {
            return String(format: "%02i:%02i", minute, second)
        }
        
        return String(format: "%02i:%02i:%02i", hour, minute, second)
    }
    
}
