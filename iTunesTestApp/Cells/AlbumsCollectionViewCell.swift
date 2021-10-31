import UIKit

class AlbumsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var genreNameLabel: UILabel!
    
    private let indicatorView = UIActivityIndicatorView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        indicatorView.frame = albumImageView.frame
    }
    
    func cellInit(data: Results, image: UIImage) {
        albumImageView.image = image
        albumNameLabel.text = data.collectionName
        artistNameLabel.text = data.artistName
        genreNameLabel.text = data.primaryGenreName
        indicatorView.removeFromSuperview()
        indicatorView.stopAnimating()
    }
    
    func initEmptyCell() {
        albumNameLabel.text = ""
        artistNameLabel.text = ""
        genreNameLabel.text = ""
        albumImageView.addSubview(indicatorView)
        indicatorView.startAnimating()
    }
    
}
