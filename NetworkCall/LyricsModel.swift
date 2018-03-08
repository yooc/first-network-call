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
    
    init() {
        dataFetcher = LyricsDataFetcher()
        
        for t in tracks {
            dataFetcher.fetchLyrics(track: t) { [weak self] (lyrics) in
                t.lyrics = lyrics
                self?.dataAvailableDelegate?.dataAvailable()
            }
        }
    }
    
    var numberofRows: Int {
        return tracks.count
    }
    
    func songLyrics(at index: Int) -> String? {
        return tracks[index].lyrics
    }
}
