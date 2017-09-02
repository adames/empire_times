require_relative '../adapters/wikiadapter.rb'

class Article < ApplicationRecord
  # here I can make articles with API calls
  def request_article(title = 'Albert_Einstein')

    article = WikiAdapter.get_article(title)
    title = article['query']['pages'].first[1]['title']
    images = article['query']['pages'].first[1]['images'].map {|img| img['title']}
    categories = article['query']['pages'].first[1]['categories'].map {|cat| cat['title']}
    extract = article['query']['pages'].first[1]['extract']


    first_image = WikiAdapter.get_picture(images[2])
    image = first_image['query']['pages'].first[1]['imageinfo'][0]['url']

    return {
      title: title,
      image: image,
      categories: categories,
      extract: extract
    }
  end

  def request_article_links(title = 'Albert_Einstein')
    links = []
    next_page = {}
    while true
      response = WikiAdapter.get_links(title, next_page)
      links.concat( response['query']['pages'].first[1]['linkshere'].map {|link| link['title']} )
      continue = response['continue'].first
      next_page = Hash[*continue]
      return links if next_page.empty? || links.count > 1000
    end
    byebug
  end
end

# All new files
      # invoke  active_record
      # create    db/migrate/20170901182012_create_articles.rb
      # create    app/models/article.rb
      # invoke    test_unit
      #
      # create      test/models/article_test.rb
      # create      test/fixtures/articles.yml
