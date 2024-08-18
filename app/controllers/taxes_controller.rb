class TaxesController < ApplicationController
  before_action :authenticate_user!
  
  def index    
    @taxes = Tax.all
   
  end
end
