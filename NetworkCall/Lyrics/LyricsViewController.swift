import UIKit

class LyricsViewController: UIViewController {

    let model = LyricsModel()
    var lyricsText = ""

    @IBOutlet weak var LyricsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LyricsLabel.text = lyricsText
    }
}
