class Document < ApplicationRecord
    has_many :products
    has_one :tax
    has_one :result
end