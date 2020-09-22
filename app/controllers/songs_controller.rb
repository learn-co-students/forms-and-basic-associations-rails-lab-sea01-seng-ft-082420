class SongsController < ApplicationController
  def index
    @songs = Song.all
  end

  def show
    @song = Song.find(params[:id])
    @notes = Note.all.select{|n| n.song_id == @song.id}
  end

  def new
    @song = Song.new
  end



  def create
    @song = Song.create(song_params)
    @song.artist = Artist.all.find{|a| a.name == params[:song][:artist_name]}
    params[:notes].reject!{|n| n.empty?}
    params[:notes].each do |note|
      new_note = Note.create(:content =>note)
      new_note[:song_id]=@song.id
      new_note.save
    end
    if @song.save
      redirect_to @song
    else
      render :new
    end
  end

  def edit
    @song = Song.find(params[:id])
  end

  def update
    @song = Song.find(params[:id])

    @song.update(song_params)

    if @song.save
      redirect_to @song
    else
      render :edit
    end
  end

  def destroy
    @song = Song.find(params[:id])
    @song.destroy
    flash[:notice] = "Song deleted."
    redirect_to songs_path
  end

  private

  def song_params
    params.require(:song).permit(:title, :artist_id, :genre_id, :artist_name, :notes=> [])
  end

  def artist_params
    params.require(:artist).permit(:name)
  end

  def note_params
    params.require(:notes).permit( :song_id)
  end
end

