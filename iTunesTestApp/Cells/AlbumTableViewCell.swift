import UIKit

class AlbumTableViewCell: UITableViewCell {

    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    func cellInit(data: Song) {
        
        songNameLabel.text = data.trackName
        
        guard let duration = data.trackTimeMillis else { return }
        
        durationLabel.text = TimeFormatter.shared.getFormattedDurationString(milliseconds: duration)
        
    }
    
}
