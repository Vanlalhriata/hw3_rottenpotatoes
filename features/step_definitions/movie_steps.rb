# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.new(movie).save
  end
  #flunk "Unimplemented"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  flunk "Unimplemented"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(%r{,\s*}).each do |rating|
    if uncheck == "un"
      uncheck("ratings_"+rating)
    else
      check ("ratings_"+rating)
    end
  end
end

# Check if movies with a particular ratings are (not) displayed

Then /I should (not)?\s*see movies with ratings: (.*)/ do |not_see, rating_list|
  rating_list.split(%r{,\s}).each do |rating|
    Movie.find_all_by_rating(rating).each do |movie|
      if page.respond_to? :should
        if not_see == "not"
          page.should have_no_content(movie.title)
        else
          page.should have_xpath('//*', :text => movie.title)
        end
      else
        if not_see == "not"
          assert page.has_no_content?(movie.title), "test"
        else
          assert page.has_xpath?('//*', :text => movie.title)
        end
      end 
    end
  end
end

# All movies displayed => displayed rows = number of movies in db

Then /I should see all of the movies/ do
  flunk "Unexpected number of movies displayed" unless
      page.all('table#movies tr').count - 1 == Movie.all.count
end
