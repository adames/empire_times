require 'httparty'

class WikiAdapter

  def self.get
    base_url = 'https://en.wikipedia.org/w/api.php' + '?'
    query = {
      titles: 'Ancient_Rome',
      formatversion: '2',
      format: 'json',
      action: 'query',
      prop: 'extracts'
    }
    query_url = query.map {|key, value| "#{key}=#{value}"}.join('&')
    full_url = base_url + query_url
    response = HTTParty.get(full_url)
    json_response = response.parsed_response
    byebug

  end
end
