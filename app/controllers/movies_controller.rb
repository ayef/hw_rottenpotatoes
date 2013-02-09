class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
@msg = "start"
  @all_ratings = Movie.get_ratings
  @ratings = Hash.new  
  if params[:ratings] == nil
@msg += "in params[ratings] == nil"
    @ratings['G']='1'
    @ratings['PG']='1'
    @ratings['PG-13']='1'
    @ratings['R']='1'
    params[:ratings] = @ratings
  else 
    @ratings['G']=0
    @ratings['PG']=0
    @ratings['PG-13']=0
    @ratings['R']=0
  end
  @filter_string = []
  params[:ratings].each do |key, value|
    if value == "1"    
      @filter_string << key 
      @ratings[key]=1
    else
      @ratings[key] = 0
    end
  end

  if params[:sort] == nil   
@msg += "in if params[:sort] == nil"
    @movies = Movie.where({:rating => @filter_string})
#@movies = Movie.all
    @hilite_column=''
  else
@msg += "in else"
    @movies = Movie.where({:rating => @filter_string}).order(params[:sort] + ' asc')
#@movies = Movie.order(params[:id] +' asc') 
    @hilite_column=params[:sort]+ '_header'
  end

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

  def sort 
   @movies = Movie.order(params[:id] +' asc') 
#redirect_to movies_path
  end

end
