json.extract! image, :id, :name, :description, :ami, :os, :login, :created_at, :updated_at
json.url image_url(image, format: :json)
