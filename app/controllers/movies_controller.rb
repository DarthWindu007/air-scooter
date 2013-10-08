class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

    savedsession = false
    @all_ratings = Movie.get_ratings
    @dic =[]
    if(params[:ratings])
         @ratings = params[:ratings]
         @ratings.keys.each{|x| @dic=@dic.push(x)}
    elsif(session[:ratings])
         @ratings = session[:ratings]
         @ratings.keys.each{|x| 
			@dic=@dic.push(x)
			savedsession = true
			} 
    else
		@all_ratings.each{|x|
		@dic = [@dic.push(x)].flatten 
		(@ratings =@ratings||{})[x]=1}
    end
	p_clicked = params[:click]
    if(p_clicked)
        @clicked = p_clicked
    elsif(session[:click])
        @clicked = session[:click]
        savedsession = true
    end
    if(savedsession)
		redirect_to movies_path(:click => @clicked, :ratings =>@ratings)
    end
    if(p_clicked)
        @list_of_movies =[]
        if(p_clicked=='title')
        Movie.all(:order=>'title').each{|x|
			if @dic.include?(x.rating) 
				@list_of_movies = (@list_of_movies.push(x)).flatten
            end
			}
        else
            Movie.all(:order=>'release_date').each{|x|
			if @dic.include?(x.rating) 
				@list_of_movies = (@list_of_movies.push(x)).flatten
			end			}
		end
    else
        @list_of_movies =[]
        Movie.all.each{|x|
        if @dic.include?(x.rating) 
			@list_of_movies = (@list_of_movies.push(x)).flatten
        end
        }
    end
    session[:click]=@clicked
    session[:ratings]=@ratings
	
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
