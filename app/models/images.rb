require_relative '../adapters/wikiadapter.rb'


class WikiImages

  def self.get_images(title = 'Albert_Einstein')
    response = WikipediaAPI.get_article_image(title)
    image_url = response['query']['pages'].first[1]['thumbnail']['source']
    return Hash["image", image_url]
  end
end
