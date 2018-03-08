import UIKit

class LyricsViewController: UIViewController {

    @IBOutlet weak var LyricsTextView: UITextView!

    var lyricsText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LyricsTextView.text = lyricsText
    }
}
