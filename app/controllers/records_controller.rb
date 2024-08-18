class RecordsController < ApplicationController
  def index
    @documents = Document.all
    @products = Product.all
    @taxes = Tax.all
    @results = Result.all
  end
end
