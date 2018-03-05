protocol DataAvailableDelegate: class {
    func dataAvailable()
}

final class LyricsModel {
    private let dataFetcher: LyricsDataFetcher
    
    weak var dataAvailableDelegate: DataAvailableDelegate?
    
    private var songList = [(artist: "Coldplay", songTitle: "Paradise"), (artist: "Gallant", songTitle: "Counting")]
    
    private var songs = [Track]()
    
    init() {
        dataFetcher = LyricsDataFetcher()
        
        dataFetcher.fetchLyrics { [weak self] (songNames) in
            self?.songs = songNames
            self?.dataAvailableDelegate?.dataAvailable()
        }
    }
    
    var numberofRows: Int {
        return songs.count
    }
    
    func artist(at index: Int) -> String? {
        return songList[index].artist
    }
    
    func songName(at index: Int) -> String? {
        return songList[index].songTitle
    }
}

class Track {
    var artist: String = ""
    var title: String = ""
    var lyrics: String = ""
}
