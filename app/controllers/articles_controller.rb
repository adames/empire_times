class ArticlesController < ApplicationController

  def get
    title = params[:title]
    render json: Article.request_article_html(title)
  end

  def search
    searchterm = params[:searchterm]
    render json: Article.search_wikipedia(searchterm)
  end

end
