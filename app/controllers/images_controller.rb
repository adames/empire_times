require "#{Rails.root}/app/models/images.rb"
#added the above because I'd like to move the model image. not a db model

class ImagesController < ApplicationController

  def get
    title = params[:title]
    render json: WikipediaAPI.get_article_image(title)
  end


end
