class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

    remember = false
    @all_ratings = Movie.get_all_ratings
    @dic =[]

    
    if params[:ratings]
         @rat = params[:ratings]
         @rat.keys.each do |x|
                @dic = @dic << x 
          end
    elsif session[:ratings]
            @rat = session[:ratings]
            @rat.keys.each do |x|    
            @dic = @dic << x
            end
            remember = true 

    else
      @all_ratings.each do |r|
      @dic = [@dic << r].flatten 
      (@rat ||= { })[r] = 1
      end
    end


    if params[:click]
        @click = params[:click]
    elsif session[:click]
            @click = session[:click]
            remember = true
    end

    


     if remember
            redirect_to movies_path(:click => @click, :ratings =>@rat)
        end



    if params[:click]
        @movies =[]
        if params[:click] == "title"
        Movie.all(:order => "title").each do |m|
        if @dic.include?(m.rating) 
                     @movies = (@movies << m).flatten
                end
        end

        else
            Movie.all(:order => "release_date").each do |m|
        if @dic.include?(m.rating) 
                     @movies = (@movies << m).flatten
                end
        end
    end
    

    else
        @movies =[]
        Movie.all.each do |m|
        if @dic.include?(m.rating) 
                     @movies = (@movies << m).flatten
             end
        end

    end


    session[:click]  = @click
    session[:ratings]=@rat
	
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
