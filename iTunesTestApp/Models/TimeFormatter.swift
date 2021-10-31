import Foundation

class TimeFormatter {
    
    static var shared: TimeFormatter {
        let instance = TimeFormatter()
        return instance
    }
    
    func getFormattedDurationString(milliseconds: Double) -> String {

        var seconds = milliseconds / 1000;
        var minutes = seconds / 60;
        seconds = seconds.truncatingRemainder(dividingBy: 60)
        let hours = minutes / 60;
        minutes = minutes.truncatingRemainder(dividingBy: 60)
        
        
        var timeComponents = Dictionary<String,Int>()
        
        timeComponents = ["hours":Int(hours), "minutes":Int(minutes),"seconds":Int(seconds)]
        
        return self.durationStringBuilder(timeComponents: timeComponents as NSDictionary?)
    }
    
    private func durationStringBuilder(timeComponents:NSDictionary?) -> String {
        
        var result:String = ""
        
        guard let timeComponents = timeComponents, timeComponents.count == 3 else {
            return result
        }
        
        let hours = setZeroPadding(timeComponent: timeComponents["hours"] as? Int, delimiter: false)
        let minutes = setZeroPadding(timeComponent: timeComponents["minutes"] as? Int, delimiter: false)
        let seconds = setZeroPadding(timeComponent: timeComponents["seconds"] as? Int, delimiter: true)
        
        if hours != "00:" {
            result.append(hours)
        }
        
        result.append(minutes)
        result.append(seconds)
        
        return result
    }
    
    private func setZeroPadding(timeComponent: Int?, delimiter: Bool) -> String {
        
        var result:String = ""
        
        guard let timeComponent = timeComponent, timeComponent > 0 else {
            if !delimiter {
                result.append("00:")
                return result
            } else {
                result.append("00")
                return result
            }
        }
        
        if(timeComponent < 10){
            if !delimiter {
                result.append("0\(timeComponent):")
            } else{
                result.append("0\(timeComponent)")
            }
        } else {
            if !delimiter {
                result.append("\(timeComponent):")
            } else{
                result.append("\(timeComponent)")
                
            }
        }
        
        return result
    }
}
