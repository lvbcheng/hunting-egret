require 'spec_helper'

describe Movie do
    let (:fake_movie1) { double('MovieA', :id=>"24" , :director => "Bob")}
    let (:bobs_movies) {[double('MovieA', :id=>"24" , :director => "Bob"),
                         double('MovieB', :id=>"25" , :director => "Bob"),
                         double('MovieC', :id=>"121", :director => "Bob"),
                         double('MovieD', :id=>"255", :director => "Bob"),
                         double('MovieE', :id=>"1"  , :director => "Bob")]}
    let (:no_dir_mov1) { double('MovieF', :id=>"43" , :director => nil)}

  it 'should return all ratings' do
    Movie.all_ratings.should == ['G','PG','PG-13','NC-17','R']
  end
  it 'is not valid without a title' do
    m = Movie.new :title=>nil
    m.should_not be_valid
  end
  it 'is valid without a director' do
    m = Movie.new :title=>'MovieA', :director=>nil
    m.should be_valid
  end
  describe 'find_all_by_director' do
    it 'should find movies whose director matches the specified director' do
      m1 = Movie.create! :title=>'MovieA', :director=>'Bob'
      m2 = Movie.create! :title=>'MovieB', :director=>'Bob'
      m3 = Movie.create! :title=>'MovieC', :director=>'Rob'
      Movie.find_all_by_director(m1.director).should == [m1, m2]
    end
    it 'should find movies whose director is nil' do
      m1 = Movie.create! :title=>'MovieA', :director=>nil
      m2 = Movie.create! :title=>'MovieB', :director=>nil
      m3 = Movie.create! :title=>'MovieC', :director=>'Rob'
      Movie.find_all_by_director(m1.director).should == [m1, m2]
    end
    it 'should return [] when it fails to find a movie' do
      m1 = Movie.create! :title=>'MovieA', :director=>'Bob'
      Movie.find_all_by_director('Rob').should == []
    end
  end
  describe 'find_by_director' do
    it 'should find a movie whose director matches the specified director' do
      m1 = Movie.create! :title=>'MovieA', :director=>'Bob'
      Movie.find_by_director(m1.director).should == m1
    end
    it 'should find a movie whose director is nil' do
      m1 = Movie.create! :title=>'MovieA', :director=>nil
      Movie.find_by_director(m1.director).should == m1
    end
    it 'should return nil when it fails to find a movie' do
      m1 = Movie.create! :title=>'MovieA', :director=>'Bob'
      Movie.find_by_director('Rob').should == nil
    end
  end
end

