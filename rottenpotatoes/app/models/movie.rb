class Movie < ActiveRecord::Base

  attr_accessible :title, :rating, :description, :release_date, :director
  validates_presence_of :title
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end
end

