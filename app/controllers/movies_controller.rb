class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
        @all_ratings = Movie.select(:rating).map(&:rating).uniq
    
    # filter when click the 'Refresh' button
    if params[:commit]
      # only filter if the checkboxes are checked
      if params[:ratings]
        # question 2
        # get all the unique rating value from the model
        @movies = Movie.where(:rating => params[:ratings].keys).order(params[:sort_by])
      end
    else
      # question 1
      # get the criteria that we need to sort_by and order it
      @movies = Movie.order(params[:sort_by])
      @column = params[:sort_by]
    end
    
    # question 3
    # restore params
    if params[:ratings]
      session[:ratings] = params[:ratings]
    end
    
    if params[:sort_by]
      session[:sort_by] = params[:sort_by]
    end
    
    # check if current values is not match with the session values and redirect them to correct value
    if session[:ratings] != params[:ratings] || session[:sort] != params[:sort]
      redirect_to movies_path(ratings: session[:ratings], sort: session[:sort])
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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
