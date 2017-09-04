require_relative '../adapters/wikiadapter.rb'
require 'nokogiri'

class Article < ApplicationRecord

  def self.parse_html(html)
    document = Nokogiri::HTML(html)
    document.css('div.mw-parser-output') #main content
    content = document.css('div.mw-parser-output').children.select do |el|
      el.node_name == 'p' ||
      el.node_name == 'h3' ||
      el.node_name == 'h2'
    end
    page_obj = {}
    h2 = 'introduction'
    h3 = 'summary'

    content.each do |node|
      if node.node_name == 'h2'
        h2 = node.text
      elsif node.node_name == 'h3'
        h3 = node.text
      elsif node.node_name == 'p'
        p_obj = {
          text: node.text,
          links: node.css('a').map{|a| a.attributes['href'].value}
        }
        page_obj[h2][h3][] << p_obj
        page_obj[h2][h3][node.text] = node
    byebug
    #TODO fix my link selector. below is clue.
    # document.css('div.mw-parser-output p')[0].css('a').map{|a| a.attributes['title'].value}
  end

  def request_article_html(title = 'Albert_Einstein')
    response = WikiAdapter.get_article_html(title)
    article = Article.parse_html(response['parse']['text']['*'])
    return {
      title: response['parse']['title'],
      article: article,
    }
  end

  def request_article_text(title = 'Albert_Einstein')
    response = WikiAdapter.get_article_text(title)
    article = response['query']['pages'].first[1]
    title = article['title']
    image_url = article['thumbnail']['source']
    categories = article['categories'].map {|cat| cat['title']}
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

      #TODO
      # The code below is broken because there aren't extracts or
      # pics on each link. either filter linkshere, filter after response (here),
      # or split into separate calls.

      byebug
      testobj = response['query']['pages'].each_with_object({}) do |link, link_obj|
        link_obj['title'] = link.first[1]['title']
        link_obj['image'] = link.first[1]['thumbnail']['source']
        link_obj['extract'] = link.first[1]['extract']
      end

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
