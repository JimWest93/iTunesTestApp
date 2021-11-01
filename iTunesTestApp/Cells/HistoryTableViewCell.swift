import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var searchRequesLabel: UILabel!
    
    func cellInit(searchRequest: String) {
        searchRequesLabel.text = searchRequest
    }

}
