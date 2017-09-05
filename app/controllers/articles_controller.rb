class ArticlesController < ApplicationController

  def find
    title = params[:title]
    render json: Article.request_article_html(title)
  end

end
