import UIKit

protocol HistoryDelegate {
    func updateCollection(searchRequest: String)
}

class HistoryViewController: UIViewController {

    @IBOutlet weak var historyTableView: UITableView!
    
    private var searchRequests = [SearchRequests]()
    private let cellID = "requestCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        historyTableView.delegate = self
        historyTableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchRequests = CoreDataManager.shared.searchRequestsData()
        historyTableView.reloadData()
    }
    
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchRequests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! HistoryTableViewCell
        if let searchRequest = searchRequests[indexPath.row].request {
            cell.cellInit(searchRequest: searchRequest)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchVC = tabBarController?.viewControllers?[0] as? SearchViewController
        searchVC?.fetchAlbums(searchRequest: searchRequests[indexPath.row].request ?? "")
        searchVC?.searchBar.text = ""
        tabBarController?.selectedIndex = 0
    }
    
}
