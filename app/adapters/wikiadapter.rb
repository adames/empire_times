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
      titles: title,
      action: 'query',
      format: 'json',
      prop: 'categories|extracts|pageimages',
      imlimit: 'max',
      cllimit: 'max',
      clshow: '!hidden',
      pithumbsize: '1000',
      explaintext: '',
    }
    response = WikiAdapter.call(query)
    return response.parsed_response
  end

  def self.get_links(title, next_page = {})
    query = {
      titles: title,
      action: 'query',
      format: 'json',
      prop: 'linkshere',
      lhnamespace: '0',
      lhlimit: 'max',
    }
    query.merge!(next_page)
    response = WikiAdapter.call(query)
    return response.parsed_response
  end

end
