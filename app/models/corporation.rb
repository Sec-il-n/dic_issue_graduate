class Corporation < ApplicationRecord
  mount_uploader :image, ImageUploader
  with_options presence: true do
    validates :name, length:{ maximum: 20 }
    validates :info, length:{ maximum: 2000 }
    validates :category
  end
  belongs_to :category, optional: true
  has_many :users, foreign_key: 'corporation_id'
end
