# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  # we save movies_created to a hash for use later when we select
  # from the database and compare the output
  @movies_created = movies_table.hashes
  movies_table.hashes.each do |movie|
    Movie.create! :title => movie["title"], :rating => movie["rating"], :release_date => movie["release_date"]
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  page.body.should =~ /.*#{e1}.*#{e2}.*/
end

# Make it easier to express checking of several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(',').each { |r|
    if uncheck == 'un'
      step %Q{I uncheck "ratings[#{r}]"}
    else
      step %Q{I check "ratings[#{r}]"}
    end
  }
end

Then /I should see all the movies/ do
  movie_titles = @movies_created.inject([]) { |a,m| a << m['title']; a }
  # Movie.find_all_by_title(movie_titles).count.should == 10
  movies_titles.each do |m|
    page.should have_content(m)
  end
end

# Verify the director
Then /the director of "(.*)" should be "(.*)"/ do |e1, e2|
  Movie.find_by_title(e1).director.should be == e2
end
