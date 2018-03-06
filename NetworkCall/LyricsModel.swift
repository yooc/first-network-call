import Foundation

protocol DataAvailableDelegate: class {
    func dataAvailable()
}

final class LyricsModel {
    private let dataFetcher: LyricsDataFetcher
    
    weak var dataAvailableDelegate: DataAvailableDelegate?
    
    let tracks = [
        Track(artist: "Coldplay", title: "Paradise", lyrics: ""),
        Track(artist: "Ed Sheeran", title: "Dive", lyrics: ""),
        Track(artist: "Calvin Harris", title: "Slide", lyrics: ""),
        Track(artist: "Gallant", title: "Counting", lyrics: ""),
        Track(artist: "dvsn", title: "Hallucinations", lyrics: ""),
        Track(artist: "Young the Giant", title: "Crystallized", lyrics: ""),
        Track(artist: "Camila", title: "Todo Cambio", lyrics: "")
        ]
    
    private var songs = [Track]()
    
    init() {
        dataFetcher = LyricsDataFetcher()
        
        for t in tracks {
            dataFetcher.fetchLyrics(track: t) { [weak self] (songNames) in
                self?.songs = songNames
                self?.dataAvailableDelegate?.dataAvailable()
            }
        }
        
    }
    
    var numberofRows: Int {
        return tracks.count
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
