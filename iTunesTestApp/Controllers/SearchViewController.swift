import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var albumsCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private let cellID = "albumCell"
    private let sidesSpacing = 10
    private let cellHeight = 60
    private var results = [Results]()
    private var searchText = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        albumsCollectionView.delegate = self
        albumsCollectionView.dataSource = self
        searchBarSetup()
    }
    
    private func searchBarSetup() {
        searchBar.delegate = self
        searchBar.placeholder = "Артисты, альбомы и др."
        searchBar.tintColor = .systemRed
    }
    
    private func configureCell(cell: AlbumsCollectionViewCell, indexPath: IndexPath) {
        cell.initEmptyCell()
        let data = results[indexPath.row]
        let urlString = data.artworkUrl60
        APIManager.shared.fetchImage(imageUrl: urlString) { image in
            cell.cellInit(data: data, image: image)
        }
    }
    
    func fetchAlbums(searchRequest: String) {
        results.removeAll()
        albumsCollectionView.reloadData()
        APIManager.shared.fetchAlbumsList(searchRequest: searchRequest) { [weak self] results in
            self?.albumsCollectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            self?.results = results.sortAlphabetically()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                self?.albumsCollectionView.reloadData()
            })
        }
    }
    
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let albumCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! AlbumsCollectionViewCell
        configureCell(cell: albumCell, indexPath: indexPath)
        return albumCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "albumVC") as! AlbumViewController
        vc.albumData = results[indexPath.row]
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cVFrame = albumsCollectionView.frame
        let cellWidth = cVFrame.width - CGFloat(sidesSpacing * 2)
        let cellHeight = CGFloat(cellHeight)
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        CoreDataManager.shared.searchRequestSaver(searchRequest: searchText)
        fetchAlbums(searchRequest: searchText)
    }
    
}


