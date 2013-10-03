require 'json'
require 'rest_client'
require 'pry'
require 'awesome_print'
require 'colorize'

if ARGV.first
  if ARGV.first.include?("r/")
    reddit_hash = JSON.parse(RestClient.get('http://reddit.com/' + ARGV.first + '.json'))
  else
    reddit_hash = JSON.parse(RestClient.get('http://reddit.com/r/' + ARGV.first + '.json'))
  end
else
  reddit_hash = JSON.parse(RestClient.get('http://reddit.com/.json'))
end

class Post

  POSTS = []

  attr_accessor :permalink, :title, :id, :votes_diff

  def initialize(permalink, title, id, upvotes, downvotes)
    self.permalink = "http://reddit.com/" + permalink
    self.title = title
    self.id = id
    self.votes_diff = upvotes - downvotes

    POSTS << self
  end

  def self.launch_story(path)
    post_to_open = POSTS.select { |post| post.id == path }[0]
    if !post_to_open
      puts "I don't recognize that story id. Please try again."
      sleep(1.2)
    else
      `open #{post_to_open.permalink}`
    end
  end

end

def make_posts(post_hash)
  data_hash = post_hash["data"]
  Post.new(data_hash["permalink"], data_hash["title"], data_hash["id"], data_hash["ups"], data_hash["downs"])
end

reddit_hash["data"]["children"].each do |post|
  unless post["data"]["over_18"] == true
    make_posts(post)
  end
end

while true
  system("clear")
  longest_votes_diff = 0
  Post::POSTS.each do |post|
    if post.votes_diff.to_s.length > longest_votes_diff
      longest_votes_diff = post.votes_diff.to_s.length
    end
  end

  Post::POSTS.each do |post|
    puts post.id.blue + '  ' + post.votes_diff.to_s.ljust(longest_votes_diff, " ").green + '  ' + post.title[0..60].black
  end
  puts ""
  print "Enter a story id, or type 'exit' to quit: "
  path = $stdin.gets.chomp

  if path == 'exit'
    break
  else
    Post.launch_story(path)
  end

end


# go through upvotes
# figure out longest one
# ljust(length)