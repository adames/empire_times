require "#{Rails.root}/app/models/images.rb"
#added the above because I'd like to move the model image. not a db model

class ImagesController < ApplicationController

  def get
    title = params[:title]
    render json: BingImages.get_images(title)
  end


end
