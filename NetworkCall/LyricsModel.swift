protocol DataAvailableDelegate: class {
    func dataAvailable()
}

final class LyricsModel {
    private let dataFetcher: LyricsDataFetcher
    
    weak var dataAvailableDelegate: DataAvailableDelegate?
    
    let firstTrack = Track(artist: "Coldplay", title: "Paradise", lyrics: "")
    
    private var songs = [Track]()
    
    init() {
        dataFetcher = LyricsDataFetcher()
        
        dataFetcher.fetchLyrics(track: firstTrack) { [weak self] (songNames) in
            self?.songs = songNames
            self?.dataAvailableDelegate?.dataAvailable()
        }
    }
    
    var numberofRows: Int {
        return songs.count
    }
    
    func artist(at index: Int) -> String? {
        return songs[index].artist
    }
    
    func songName(at index: Int) -> String? {
        return songs[index].title
    }
    
    func songLyrics(at index: Int) -> String? {
        return songs[index].lyrics
    }
}
