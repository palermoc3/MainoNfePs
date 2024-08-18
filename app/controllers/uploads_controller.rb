class UploadsController < ApplicationController
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
      parse_and_save_xml(xml_file)

      redirect_to @upload, notice: 'Arquivo XML foi carregado e processado com sucesso.'
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

  def parse_and_save_xml(file_content)
    require 'nokogiri'

    # Abra e leia o conteúdo do arquivo XML
    doc = Nokogiri::XML(file_content)
    namespace = 'http://www.portalfiscal.inf.br/nfe'

    # Crie o documento
    document = Document.create(
      serie: doc.at_xpath('//nfe:ide/nfe:serie', 'nfe' => namespace)&.text&.strip,
      nNF: doc.at_xpath('//nfe:ide/nfe:nNF', 'nfe' => namespace)&.text&.strip,
      dhEmi: doc.at_xpath('//nfe:ide/nfe:dhEmi', 'nfe' => namespace)&.text&.strip,
      emit_cnpj: doc.at_xpath('//nfe:emit/nfe:CNPJ', 'nfe' => namespace)&.text&.strip,
      emit_xNome: doc.at_xpath('//nfe:emit/nfe:xNome', 'nfe' => namespace)&.text&.strip,
      dest_cnpj: doc.at_xpath('//nfe:dest/nfe:CNPJ', 'nfe' => namespace)&.text&.strip,
      dest_xNome: doc.at_xpath('//nfe:dest/nfe:xNome', 'nfe' => namespace)&.text&.strip
    )

    if document.persisted?
      # Processa produtos
      doc.xpath('//nfe:det', 'nfe' => namespace).each do |det|
        prod = det.at_xpath('nfe:prod', 'nfe' => namespace)
        Product.create(
          document: document,
          name: prod.at_xpath('nfe:xProd', 'nfe' => namespace)&.text&.strip,
          NCM: prod.at_xpath('nfe:NCM', 'nfe' => namespace)&.text&.strip,
          CFOP: prod.at_xpath('nfe:CFOP', 'nfe' => namespace)&.text&.strip,
          uCom: prod.at_xpath('nfe:uCom', 'nfe' => namespace)&.text&.strip,
          qCom: prod.at_xpath('nfe:qCom', 'nfe' => namespace)&.text&.strip.to_d,
          vUnCom: prod.at_xpath('nfe:vUnCom', 'nfe' => namespace)&.text&.strip.to_d
        )
      end

      # Processa impostos
      Tax.create(
        document: document,
        vICMS: doc.at_xpath('//nfe:ICMS00/nfe:vICMS', 'nfe' => namespace)&.text&.strip.to_d,
        vIPI: doc.at_xpath('//nfe:IPITrib/nfe:vIPI', 'nfe' => namespace)&.text&.strip.to_d,
        vPIS: doc.at_xpath('//nfe:PIS/nfe:vPIS', 'nfe' => namespace)&.text&.strip.to_d,
        vCOFINS: doc.at_xpath('//nfe:COFINS/nfe:vCOFINS', 'nfe' => namespace)&.text&.strip.to_d
      )
    end

    # Calcula o resultado
    total_tax = Tax.where(document: document).sum do |tax|
      tax.vICMS.to_d + tax.vIPI.to_d + tax.vPIS.to_d + tax.vCOFINS.to_d
    end

    total_product_value = Product.where(document: document).sum do |product|
      BigDecimal(product.qCom.to_s) * BigDecimal(product.vUnCom.to_s)
    end

    Result.create(
      document: document,
      tax: total_tax,
      product_value: total_product_value
    )
  end
end
