import UIKit

class AlbumViewController: UIViewController {
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var songsTableView: UITableView!
    
    private let indicatorView = UIActivityIndicatorView()
    
    private var inputDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        return dateFormatter
    }()
    
    private var outputDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter
    }()
    
    private let cellID = "songCell"
    
    var albumData: Album?
    var songs = [Song]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelsSetup()
        songsTableView.delegate = self
        songsTableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        coverViewSetup()
        view.addSubview(indicatorView)
        getSongsData()
    }

    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func getSongsData() {
        guard let id = albumData?.collectionID else { return }
        APIManager.shared.fetchTracks(collectionID: id) { [weak self] songs in
            self?.songs = songs
            self?.songsTableView.reloadData()
        }
    }
    
    private func labelsSetup() {
        albumNameLabel.text = albumData?.collectionName
        artistNameLabel.text = albumData?.artistName
        genreLabel.text = albumData?.primaryGenreName
        let date = inputDateFormatter.date(from: albumData?.releaseDate ?? "")
        if let date = date {
            yearLabel.text = outputDateFormatter.string(from: date)
        }
    }
    
    private func coverViewSetup() {
        coverImageView.shadowAndRoundedCorners(containerView: containerView, cornerRadious: 10)
        indicatorView.frame = containerView.frame
        indicatorView.startAnimating()
        
        if let imageUrl = albumData?.artworkUrl100.replacingOccurrences(of: "100x100", with: "600x600") {
            APIManager.shared.fetchImage(imageUrl: imageUrl) { [weak self] image in
                self?.coverImageView.image = image
                self?.indicatorView.stopAnimating()
                self?.indicatorView.removeFromSuperview()
            }
        }
        
    }
    
}

extension AlbumViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let songCell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! AlbumTableViewCell
        songCell.cellInit(data: songs[indexPath.row])
        return songCell
    }
    
}
