import UIKit

class LyricsViewController: UIViewController {

    let model = LyricsModel()
    var lyricsText = ""

    @IBOutlet weak var LyricsTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LyricsTextView.text = lyricsText
    }
}
