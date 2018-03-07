import UIKit

class NetworkCallViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let dataModel = LyricsModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataModel.dataAvailableDelegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let lyricsViewController = segue.destination as? LyricsViewController, let lyricsText = sender as? String {
            lyricsViewController.lyricsText = lyricsText
        }
    }

}

//MARK: - UITableViewDataSource
extension NetworkCallViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "songCell") else { return UITableViewCell() }
        cell.textLabel?.text = "\(dataModel.tracks[indexPath.row].title) - \(dataModel.tracks[indexPath.row].artist)"
        return cell
    }
}

//MARK: - DataAvailableDelegate
extension NetworkCallViewController: DataAvailableDelegate {
    func dataAvailable() {
        tableView.reloadData()
    }
}

//MARK: - UITableViewDelegate
extension NetworkCallViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showLyrics", sender: dataModel.songLyrics(at: indexPath.row))
    }
}
