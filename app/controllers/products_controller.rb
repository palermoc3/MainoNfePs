class ProductsController < ApplicationController
  def index
    @search_query = params[:search].presence || ''
    
    @products = Product.where('name ILIKE ?', "%#{@search_query}%")
  end
end
