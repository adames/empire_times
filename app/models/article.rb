require_relative '../adapters/wikiadapter.rb'
require 'nokogiri'

class WikipediaText

  def self.request_html(title = 'Albert_Einstein')

    response = WikipediaAPI.get_article_html(title)
    article = WikipediaText.parse_html(response['parse']['text']['*'])
    return {
      title: response['parse']['title'],
      article: article,
    }
  end

  def self.parse_html(html)
    document = Nokogiri::HTML(html)
    document.css('div.mw-parser-output') #main content
    content = document.css('div.mw-parser-output').children.select do |el|
      el.node_name == 'p' ||
      el.node_name == 'h3' ||
      el.node_name == 'h2'
    end
    h2 = 'Overview'
    h3 = 'Synopsis'
    page_obj = {h2 => {h3 => []}}

    content.each do |node|
      if node.node_name == 'h2'
        h2 = WikipediaText.clean_edits(node.text)
        h3 = h2
        page_obj[h2] = {}
      elsif node.node_name == 'h3'
        h3 = WikipediaText.clean_edits(node.text)
        page_obj[h2].merge(h3 => [])
      elsif node.node_name == 'p'
        next if node.text == "" || node.text[0..11] == "Coordinates:"

        article_links = node.css('a').map do |a|
          if a.attributes['title']
            a.attributes['title'].value
          end
        end.compact

        p_obj = {
          "text" => WikipediaText.clean_edits(WikipediaText.clean_citations(node.text)),
          "links" => article_links
        }

        if page_obj[h2].nil?
          page_obj['Summary'] = {'Introduction' => [p_obj]}
        elsif page_obj[h2][h3].nil?
          page_obj[h2][h3] = [p_obj]
        else
          page_obj[h2][h3] << p_obj
        end
      end
    end
    #finally, i want to remove:
      # See Also
      # Notes
      # References
      # Further reading
      # External links
    superfulous_h2s = ['See Also', 'Notes', 'References', 'Further reading', 'External links']
    superfulous_h2s.each { |k| page_obj.delete k }


    return page_obj
  end

  # # Runs all cleaners.
  # def remove_all_complex_text(text)
  #   clean_text = text.clone
  #   clean_text = clean_citations(clean_text)
  #   clean_text = clean_edits(text)
  # end

  def self.clean_citations(text)
    text.gsub(/(\[\d+\])+(\:\d+)*/,"") #removes citation (+ colon digits)
    #other possible fix: (\[\d+?\])+(\:\d+)*
  end

  def self.clean_edits(text)
    text.gsub(/(\[\w+\])/,"") #removes [edit] from headers
    #other possible fix: (\[\d+?\])+(\:\d+)*
  end

  def self.search_wikipedia(searchterm = 'Albert_Einstein')
    responses = WikipediaAPI.search_titles(searchterm)
    responses[1].map.with_index do |r, i|
      {
        title: r,
        description: responses[2][i],
      }
    end
  end

  def self.request_preview(titles = 'Albert_Einstein|Ancient_Rome')
    response = WikipediaAPI.get_links(titles)
    return response['query']['pages'].map do |article, article_info|
      link_obj = {}
      link_obj['title'] = article_info['title']
      link_obj['image'] = article_info['thumbnail']['source'] unless article_info['thumbnail'].nil?
      link_obj['extract'] = article_info['extract']
      link_obj
    end
  end
end

  #TODO
    # send requests (make sure cycle complete)
    # take out any unnessary data from call
    # make sure data gets back to article from adapter
    # pull necessary info for object
    # return info to controller


# Obsolete code
# def request_article_text(title = 'Albert_Einstein')
#   response = WikipediaAPI.get_article_text(title)
#   article = response['query']['pages'].first[1]
#   title = article['title']
#   image_url = article['thumbnail']['source']
#   categories = article['categories'].map {|cat| cat['title']}
#   extract = article['extract']
#   byebug
#   return {
#     title: title,
#     image_url: image_url,
#     categories: categories,
#     extract: extract
#   }
# end

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
