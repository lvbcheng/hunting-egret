require 'spec_helper'

describe Movie do
  let! (:m1) { Movie.create! :title =>'MovieA', :director => 'Bob' }
  let! (:m2) { Movie.create! :title =>'MovieB', :director => 'Rob' }
  let! (:m3) { Movie.create! :title =>'MovieC', :director => 'Bob' }
  let! (:m4) { Movie.create! :title =>'MovieD', :director => 'Bob' }

  it 'should return all ratings' do
    Movie.all_ratings.should == ['G','PG','PG-13','NC-17','R']
  end
  it 'is not valid without a title' do
    m1.title = nil
    m1.should_not be_valid
  end
  it 'is valid without a director' do
    m1.should be_valid
  end
  describe 'find_all_by_director' do
    it 'should find movies whose director matches the specified director' do
      Movie.find_all_by_director(m1.director).should == [m1, m3, m4]
    end
    it 'should find movies whose director is nil' do
      m5 = Movie.create! :title =>'MovieE'
      m6 = Movie.create! :title =>'MovieF'
      m7 = Movie.create! :title =>'MovieG'
      m8 = Movie.create! :title =>'MovieH'

      Movie.find_all_by_director(m5.director).should == [m5, m6, m7, m8]
    end
    it 'should return [] when it fails to find a movie' do
      Movie.find_all_by_director('No Such').should == []
    end
  end
  describe 'find_by_director' do
    it 'should find a movie whose director matches the specified director' do
      m9 = Movie.create! :title=>'MovieA', :director=>'Bobby'
      Movie.find_by_director(m9.director).should == m9
    end
    it 'should find a movie whose director is nil' do
      m9 = Movie.create! :title=>'MovieA'
      Movie.find_by_director(m9.director).should == m9
    end
    it 'should return nil when it fails to find a movie' do
      Movie.find_by_director('No Such').should == nil
    end
  end
end

