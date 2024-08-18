class RecordsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @documents = Document.all
    @products = Product.all
    @taxes = Tax.all
    @results = Result.all
  end
end
