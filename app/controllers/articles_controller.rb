require "#{Rails.root}/app/models/article.rb"
#added the above because I'd like to move the model article. not a db model

class ArticlesController < ApplicationController

  def get
    title = params[:title]
    render json: WikipediaText.request_html(title)
  end

  def search
    searchterm = params[:searchterm]
    render json: WikipediaText.search_wikipedia(searchterm)
  end

  def related
    titles = params[:titles]
    render json: WikipediaText.request_preview(titles)
  end

end
