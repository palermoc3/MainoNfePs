class UploadsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_upload, only: %i[show]

  # GET /uploads/new
  def new
    @upload = Upload.new
  end

  # POST /uploads
  def create
    @upload = Upload.new(upload_params)
    if @upload.save
      # Obtenha o arquivo XML associado ao upload
      xml_file = @upload.xml_file.download

      # Salve e processe o XML
      ProcessXmlJob.perform_later(@upload.id)

      redirect_to records_index_path, notice: "Arquivo XML foi carregado e processado com sucesso."
    else
      render :new
    end
  end

  # GET /uploads/:id
  def show
  end

  private

  def set_upload
    @upload = Upload.find(params[:id])
  end

  def upload_params
    params.require(:upload).permit(:xml_file)
  end
end
