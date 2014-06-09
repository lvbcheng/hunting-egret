require 'spec_helper'

describe MoviesController do
#  describe 'show' do
#    it 'should show movies with no director'
#    it 'should show movies with a director'
#  end
#
#  describe 'index' do
#    it 'should display all movies'
#    it 'should sort movies by title'
#    it 'should sort movies by release date'
#    it 'should sort movies by director'
#    it 'should filter movies'
#  end
#
#  describe 'new' do
#    it 'should allow new of a movie with no director'
#    it 'should allow new of a movie with a director'
#  end
#
# describe 'create' do
#  it 'should allow creation of a movie with no director'
#  it 'should allow creation of a movie with a director'
# end
#
#  describe 'edit' do
#    it 'should allow edit of a movie with no director'
#    it 'should allow edit of a movie with a director'
#  end
#
#  describe 'update' do
#    before(:each) do
#      @fake_movie = Factory(:movie)
#    end
#    it 'should update a movie with director to no director' do
#      @attr = {:director=>nil}
#      put :update, :id=>@fake_movie.id, :movie => @attr
#    end
#    it 'should update a movie with a director to no director'
#  end

  describe 'sdirector' do
#    it 'should display all movies'
#    it 'should sort movies by title'
#    it 'should sort movies by release date'
#    it 'should sort movies by director'
#    it 'should filter movies by rating'
    let (:fake_movie1) { double(:title=>'MovieA', :id=>"24" , :director => "Bob")}
    let (:bobs_movies) {[double(:title=>'MovieA', :id=>"24" , :director => "Bob"),
                         double(:title=>'MovieB', :id=>"25" , :director => "Bob"),
                         double(:title=>'MovieC', :id=>"121", :director => "Bob"),
                         double(:title=>'MovieD', :id=>"255", :director => "Bob"),
                         double(:title=>'MovieE', :id=>"1"  , :director => "Bob")]}
    let (:no_dir_mov1) { double(:title=>'MovieF', :id=>"43" , :director => nil)}
    it 'should call the Movie model to find the movie with the id' do
      # set up expectations
      Movie.should_receive(:find).with(fake_movie1.id).and_return(fake_movie1)
      # get ball rolling by mocking the http request
      get :sdirector, :id => fake_movie1.id
    end

    it 'should find all the movies by the same director' do
      # stub the methods
      Movie.stub(:find).and_return(fake_movie1)
      # set expectations
      Movie.should_receive(:find_all_by_director).with(fake_movie1.director).and_return(bobs_movies)
      # get ball rolling by mocking the http request
      get :sdirector, :id => fake_movie1.id
    end

    it 'should select the sdirector template for rendering' do
       Movie.stub(:find).and_return(fake_movie1)
       Movie.stub(:find_all_by_director).and_return(bobs_movies)
      # get ball rolling by mocking the http request
      get :sdirector, :id => fake_movie1.id
      response.should render_template('sdirector')
    end

    it 'should make the result available to the template' do
      Movie.stub(:find).and_return(fake_movie1)
      Movie.stub(:find_all_by_director).and_return(bobs_movies)
      # get ball rolling by mocking the http request
      get :sdirector, :id => fake_movie1.id
      assigns(:the_movie).should == fake_movie1
      assigns(:movies).should    == bobs_movies
    end

    it 'should redirect to the home page with a message when director is nil' do
      Movie.stub(:find).and_return(no_dir_mov1)
      Movie.should_not_receive(:find_all_by_director)
      get :sdirector, :id => no_dir_mov1.id
      flash[:notice].should eq("'#{no_dir_mov1.title}' has no director info")
      response.should redirect_to(:action => "index")
    end

   it 'should deal with potentially bogus director info' do
     # stub the methods
     Movie.stub(:find).and_return(fake_movie1)
     Movie.stub(:find_all_by_director).and_return([]) # return empty
     get :sdirector, :id => fake_movie1.id
     flash[:notice].should eq("No movies found with director #{fake_movie1.director}")
     response.should redirect_to(:action => "index")
   end
  end
end

