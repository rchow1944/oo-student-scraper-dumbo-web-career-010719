require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    html = File.read(index_url)
    learn_students = Nokogiri::HTML(html)
    # binding.pry
    students = learn_students.css("div.student-card")

    students.map {|student|
      {
        :name => student.css("h4.student-name").text,
        :location => student.css("p.student-location").text,
        :profile_url => student.css("a").attribute("href").value
      }
    }
  end

  def self.scrape_profile_page(profile_url)
    html = File.read(profile_url)
    profile = Nokogiri::HTML(html)
    social_links = profile.css("div.social-icon-container a").map{|link| link.attribute("href").value}
    profile_name = profile.css("h1.profile-name").text
    # binding.pry
    # twitter = social_links.find{|link| link.include?("twitter.com")}
    # linkedin = social_links.find{|link| link.include?("linkedin.com")}
    # github = social_links.find{|link| link.include?("github.com")}
    # blog = social_links.find{|link| link.include?(profile_name.split[1].downcase+".com")}
    student = {
      :bio => profile.css("div.description-holder p").text,
      :profile_quote => profile.css("div.profile-quote").text
    }
    social_links.each{|link|
      if link.include?("twitter.com")
        student[:twitter] = link
      elsif link.include?("linkedin.com")
        student[:linkedin] = link
      elsif link.include?("github.com")
        student[:github] = link
      else
        student[:blog] = link
      end
    }

    student
  end

end

# Scraper.scrape_index_page("./fixtures/student-site/index.html")
# Scraper.scrape_profile_page("./fixtures/student-site/students/ryan-johnson.html")
#Student Name = learn_students.css("div.student-card").first.css("h4.student-name").text
#Student Location = student.css("p.student-location").text
#Student URL = student.first.css("a").attribute("href").value

#Profile Bio = profile.css("div.description-holder p").text
#Github = profile.css("div.social-icon-container a:nth-child(3)").attribute("href").value
