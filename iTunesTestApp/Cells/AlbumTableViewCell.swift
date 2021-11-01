import UIKit

class AlbumTableViewCell: UITableViewCell {

    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    func cellInit(data: Song) {
        songNameLabel.text = data.trackName
        guard let duration = data.trackTimeMillis else { return }
        durationLabel.text = duration.getFormattedDurationString() // перевод длительности трека в миллисекундах в строку формата "00:00:00"
    }
    
}
