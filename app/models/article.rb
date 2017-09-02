require_relative '../adapters/wikiadapter.rb'

class Article < ApplicationRecord

  def request_article(title = 'Albert_Einstein')
    response = WikiAdapter.get_article(title)
    article = response['query']['pages'].first[1]
    title = article['title']
    image_url = article['thumbnail']['source']
    categories = article['categories'].map {|cat| cat['title'].slice(9..-1)}
    extract = article['extract']
    byebug
    return {
      title: title,
      image_url: image_url,
      categories: categories,
      extract: extract
    }
  end

  def request_article_links(title = 'Albert_Einstein')
    links = []
    continue_query = {}
    while links.count < 12000
      response = WikiAdapter.get_links(title, continue_query)
      links.concat( response['query']['pages'].first[1]['linkshere'].map {|link| link['title']} )
      if response['continue'].nil?
        return links
      else
        continue = response['continue'].first
        continue_query = Hash[*continue]
      end
    end

  end
end

# What DJ uses to traverse hashes
# def self.check(hash, key, ret = [])
#   hash.each do |k, v|
#     if k == key
#       ret << [k, v]
#     else
#       if v.class == Hash
#         check(v, ret, key)
#       end
#     end
#   end
#   ret.flatten[1]
# end
