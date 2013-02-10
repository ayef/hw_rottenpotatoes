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

  if params[:ratings] != nil && params[:sort] != nil
    session[:ratings] = params[:ratings]
    session[:sort] = params[:sort]

  elsif params[:ratings] != nil && params[:sort] == nil
    session[:ratings] = params[:ratings]
    if session[:sort] != nil
      params[:sort] = session[:sort]
      flash.keep
      redirect_to :action => "index", :controller => "movies", :sort => params[:sort], :ratings => params[:ratings]
    end
  elsif params[:ratings] == nil && params[:sort] != nil
    session[:sort] = params[:sort]
    if session[:ratings] != nil
      params[:ratings] = session[:ratings]
      flash.keep
      redirect_to :action => "index", :controller => "movies", :sort => params[:sort], :ratings => params[:ratings]
    else
      @ratings['G']='1'
      @ratings['PG']='1'
      @ratings['PG-13']='1'
      @ratings['R']='1'
      params[:ratings] = @ratings
      session[:ratings] = params[:ratings]
    end

  else #arams[:ratings] == nil && params[:sort] == nil
    if session[:ratings] != nil && session[:sort] != nil
      params[:ratings] = session[:ratings]
      params[:sort] = session[:sort]
      flash.keep
      redirect_to :action => "index", :controller => "movies", :sort => params[:sort], :ratings => params[:ratings]
    elsif session[:ratings] == nil && session[:sort] != nil
      params[:sort] = session[:sort]
      @ratings['G']='1'
      @ratings['PG']='1'
      @ratings['PG-13']='1'
      @ratings['R']='1'
      params[:ratings] = @ratings
      session[:ratings] = params[:ratings]
      flash.keep
      redirect_to :action => "index", :controller => "movies", :sort => params[:sort], :ratings => params[:ratings]
    elsif session[:rating] != nil && session[:sort] == nil
      params[:ratings] = session[:ratings]
      flash.keep
      redirect_to :action => "index", :controller => "movies", :ratings => params[:ratings]
    else
      @ratings['G']='1'
      @ratings['PG']='1'
      @ratings['PG-13']='1'
      @ratings['R']='1'
      params[:ratings] = @ratings
      session[:ratings] = params[:ratings]
    end


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
    session[:sort] = params[:sort]
    
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
  end

end
