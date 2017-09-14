require_relative '../adapters/pixabayapi.rb'


class PixabayImages

  def self.get_images(title = 'Albert_Einstein')
    response = PixabayAPI.images(title)
    byebug
    return response['hits'].map { |image| image['webformatURL'] }
  end
end
