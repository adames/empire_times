require 'httparty'


class WikiAdapter

  def self.get_article(title)
    base_url = 'https://en.wikipedia.org/w/api.php' + '?'
    query = {
      action: 'query',
      format: 'json',
      prop: 'linkshere|images|categories|coordinates|extracts',
      lhnamespace: '0',
      titles: title,
      explaintext: ''
    }
    query_url = query.map {|key, value| "#{key}=#{value}"}.join('&')
    full_url = base_url + query_url
    response = HTTParty.get(full_url)
    return response.parsed_response
  end

  def self.get_links(title = 'Albert_Einstein')
    base_url = 'https://en.wikipedia.org/w/api.php' + '?'
    query = {
      action: 'query',
      format: 'json',
      prop: 'links',
      titles: title,
      pllimit: 'max',
      plnamespace: '0'
    }
    query_url = query.map {|key, value| "#{key}=#{value}"}.join('&')
    full_url = base_url + query_url
    response = HTTParty.get(full_url)
    return response.parsed_response
  end

  def self.get_picture(title = 'Albert_Einstein')
    base_url = 'https://en.wikipedia.org/w/api.php' + '?'
    query = {
      action: 'query',
      format: 'json',
      prop: 'imageinfo',
      iiprop: 'url',
      titles: title
    }
    query_url = query.map {|key, value| "#{key}=#{value}"}.join('&')
    full_url = base_url + query_url
    response = HTTParty.get(full_url)
    return response.parsed_response
  end


end
