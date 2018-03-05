class Track: Hashable {
    static func ==(lhs: Track, rhs: Track) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    var hashValue: Int {
        return (lyrics.count).hashValue
    }
    
    var artist: String
    var title: String
    var lyrics: String
    
    init(artist: String, title: String, lyrics: String) {
        self.artist = artist
        self.title = title
        self.lyrics = lyrics
    }
}
