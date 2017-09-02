require 'httparty'

class WikiAdapter

  def self.call(query)
    base_url = 'https://en.wikipedia.org/w/api.php' + '?'
    query_url = query.map {|key, value| "#{key}=#{value}"}.join('&')
    full_url = base_url + query_url
    return HTTParty.get(full_url)
  end

  def self.get_article(title)
    query = {
      action: 'query',
      format: 'json',
      prop: 'images|categories|coordinates|extracts',
      lhnamespace: '0',
      titles: title,
      explaintext: ''
    }
    response = WikiAdapter.call(query)
    return response.parsed_response
  end

  def self.get_links(title, next_page = {})
    query = {
      action: 'query',
      format: 'json',
      prop: 'linkshere',
      lhnamespace: '0',
      titles: title,
      explaintext: ''
    }
    query.merge!(next_page)
    response = WikiAdapter.call(query)
    return response.parsed_response
  end

  def self.get_picture(title = 'Albert_Einstein')
    query = {
      action: 'query',
      format: 'json',
      prop: 'imageinfo',
      iiprop: 'url',
      titles: title
    }
    response = WikiAdapter.call(query)
    return response.parsed_response
  end

end
