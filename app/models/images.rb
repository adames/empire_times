require_relative '../adapters/wikiadapter.rb'


class WikiImages

  def self.get_images(title = 'Albert_Einstein')
    response = WikipediaAPI.get_article_image(title)
    return response['query']['pages'].first[1]['thumbnail']['source']
  end
end
