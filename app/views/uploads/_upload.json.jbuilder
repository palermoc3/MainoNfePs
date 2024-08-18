json.extract! upload, :id, :xml_file, :created_at, :updated_at
json.url upload_url(upload, format: :json)
json.xml_file url_for(upload.xml_file)
