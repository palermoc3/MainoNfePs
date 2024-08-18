class ProductsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @search_query = params[:search].presence || ''
    
    @products = Product.where('name ILIKE ?', "%#{@search_query}%")
  end
end
