require 'httparty'

class PixabayAPI

  def self.call(query)
    base_url = 'https://pixabay.com/api/'
    # headers = {
    #
    # }

    return HTTParty.get(
      base_url,
      :query => query
    )
  end

  def self.images(title)
    query = {
      "q" => title,
      "lang" => 'en',
      "per_page" => '100',
      "key"  => ENV["pixabay_api_key"],
    }

    response = PixabayAPI.call(query)
    return response.parsed_response
  end

end
