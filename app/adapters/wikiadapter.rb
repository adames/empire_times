require 'httparty'
require 'uri'

class WikipediaAPI

  def self.call(query)
    base_url = 'https://en.wikipedia.org/w/api.php' + '?'
    query_url = query.map {|key, value| "#{key}=#{value}"}.join('&')
    ready_url = URI.encode(base_url + query_url)
    return HTTParty.get(ready_url)
  end

  def self.get_article_html(title)
    query = {
      page: title,
      action: 'parse',
      format: 'json',
      prop: 'text',
    }
    response = WikipediaAPI.call(query)
    return response.parsed_response
  end

  def self.search_titles(searchterm)
    query = {
      search: searchterm,
      action: 'opensearch',
      profile: 'fuzzy',
      format: 'json',
      limit: '8',
      namespace: '0',
      redirect: 'resolve',
    }
    response = WikipediaAPI.call(query)
    return response.parsed_response
  end

  def self.get_article_text(title)
    query = {
      titles: title,
      action: 'query',
      format: 'json',
      prop: 'categories|extracts',
      cllimit: 'max',
      clshow: '!hidden',
      pithumbsize: '1000',
    }
    response = WikipediaAPI.call(query)
    return response.parsed_response
  end

  def self.get_article_image(title)
    query = {
      titles: title,
      action: 'query',
      format: 'json',
      prop: 'pageimages',
      pithumbsize: '1000',
    }
    response = WikipediaAPI.call(query)
    return response.parsed_response
  end

  def self.get_links(titles)
    query = {
      titles: titles,
      action: 'query',
      format: 'json',
      prop: 'pageimages|extracts',
      namespace: '0',
      pithumbsize: '1000',
      exchars: '250',
      exlimit: '20',
      explaintext: '',
      exintro: '',
      redirects: '',
    }
    response = WikipediaAPI.call(query)
    return response.parsed_response
  end

end
