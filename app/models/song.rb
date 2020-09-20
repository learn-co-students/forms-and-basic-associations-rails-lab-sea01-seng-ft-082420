class Song < ActiveRecord::Base
  belongs_to :artist
  belongs_to :genre
  has_many :notes

  def artist_name=(artist)
    self.artist = Artist.find_or_create_by(name: artist)
  end

  def artist_name
    self.artist ? self.artist.name : nil
  end

  def new_notes=(text)
    text.each do |t|
      new_note = Note.create(content: t, song_id: self.id)
      self.notes << new_note
    end
  end
end
