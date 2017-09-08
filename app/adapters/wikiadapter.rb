require 'httparty'

class WikiAdapter

  def self.call(query)
    base_url = 'https://en.wikipedia.org/w/api.php' + '?'
    query_url = query.map {|key, value| "#{key}=#{value}"}.join('&')
    full_url = base_url + query_url
    return HTTParty.get(full_url)
  end

  def self.get_article_html(title)
    query = {
      page: title,
      action: 'parse',
      format: 'json',
      prop: 'text',
    }
    response = WikiAdapter.call(query)
    return response.parsed_response
  end

  def self.search_titles(searchterm)
    query = {
      search: searchterm,
      action: 'opensearch',
      profile: 'fuzzy',
      format: 'json',
      limit: '5',
      namespace: '0',
      redirect: 'resolve',
    }
    response = WikiAdapter.call(query)
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
    response = WikiAdapter.call(query)
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
    response = WikiAdapter.call(query)
    return response.parsed_response
  end

  def self.get_links(titles)
    query = {
      titles: titles,
      action: 'query',
      format: 'json',
      prop: 'pageimages|extracts',
      plprop: 'title',
      plshow: '!redirect',
      plnamespace: '0',
      pllimit: 'max',
      exintro: '',
      explaintext: '',
    }
    query.merge!(next_page)
    response = WikiAdapter.call(query)
    return response.parsed_response
  end

end
