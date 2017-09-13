require_relative '../adapters/bingadapter.rb'


class BingImages

  def self.get_images(title = 'Albert_Einstein')
    response = BingAPI.images(title)
    return response['value'].map { |image| image['contentUrl'] }
  end
end
