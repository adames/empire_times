require 'httparty'

class BingAPI

  def self.call(query)
    base_url = 'https://api.cognitive.microsoft.com/bing/v7.0/images/search'
    headers = {
      "Ocp-Apim-Subscription-Key"  => ENV["Ocp-Apim-Subscription-Key"],
      "X-MSEdge-ClientID" => ENV["X-MSEdge-ClientID"]
    }

    return HTTParty.get(
      base_url,
      :query => query,
      :headers => headers
    )
  end

  def self.images(title)
    query = {
      "q" => title,
      "mkt" => 'en-us',
    }

    response = BingAPI.call(query)
    return response.parsed_response
  end

end
