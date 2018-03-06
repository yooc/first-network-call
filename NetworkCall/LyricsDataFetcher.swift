import Foundation

typealias JsonDictionary = [String: Any]

class LyricsDataFetcher {
    func fetchLyrics(trackArray: [[Track]], completion: @escaping ([Track]) -> ()) {
        guard let lyricsURL = URL(string: "https://api.lyrics.ovh/v1/\(trackArray[0][0].artist)/\(trackArray[0][0].title)") else {
            print("URL did not instantiate")
            completion([])
            return
        }
        
        let task = URLSession.shared.dataTask(with: lyricsURL) { (data, urlResponse, error) in
            guard let data = data else {
                print("No data")
                DispatchQueue.main.async {
                    completion([])
                }
                return
            }
            
            guard let jsonData = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)  else {
                print("JSON serialization failed")
                DispatchQueue.main.async {
                    completion([])
                }
                return
            }
            
            guard let songData = [jsonData] as? [[String: Any]] else {
                print("Data was not an array of dictionaries")
                DispatchQueue.main.async {
                    completion([])
                }
                return
            }
            
            let allLyrics = songData.flatMap { songDictionary in
                guard let lyric = songDictionary["lyrics"] as? String else { return nil }
                return lyric
            }
            
            let newTrack = Track(artist: trackArray[0][0].artist, title: trackArray[0][0].title, lyrics: allLyrics[0])
//            print("Artist: \(newTrack.artist)")
//            print("Title: \(newTrack.title)")
//            print("Lyrics: \(newTrack.lyrics)")

            DispatchQueue.main.async {
                completion([newTrack])
            }
        }
        
        task.resume()
    }
}

