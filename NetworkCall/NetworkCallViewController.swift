import UIKit

class NetworkCallViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let dataModel = LyricsModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataModel.dataAvailableDelegate = self
    }

}

extension NetworkCallViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Number of Rows")
        return dataModel.numberofRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath)
        cell.textLabel?.text = dataModel.songName(at: indexPath.row)
        print("Cell for Row")
        return cell
    }
}

extension NetworkCallViewController: DataAvailableDelegate {
    func dataAvailable() {
        tableView.reloadData()
    }
}
