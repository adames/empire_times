class ArticlesController < ApplicationController

  def create
    a = Article.new
    byebug
    render json: a.request_article
  end

end
