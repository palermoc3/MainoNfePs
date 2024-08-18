class DocumentsController < ApplicationController
  def index
    @search_query = params[:search].presence || ''
    
    @documents = Document.where('serie ILIKE ?', "%#{@search_query}%")
  end
end
