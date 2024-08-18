class ResultsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @results = Result.all
  end
end
