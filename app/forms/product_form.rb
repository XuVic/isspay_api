class ProductForm < BaseForm
  
  delegate :name, :price, :quantity, :image_url, :category_id, to: :target_resource

  def self.in_create(resource, options = {})
    validates :name, presence: true, uniqueness: true
    validates :price, presence: true, numericality: { greater_than: -1 }
    validates :quantity, presence: true, numericality: { greater_than: -1 }
    validates :image_url, length: { maximum: 50 }, presence: true
    validates :category_id, presence: true
    super(resource, options)
  end

  def self.in_update(resource, options = {})
    validates :name, uniqueness: true, if: :name
    validates :price, numericality: { greater_than: -1 }, if: :price
    validates :quantity, numericality: { greater_than: -1 }, if: :quantity
    validates :image_url, length: { maximum: 50 }, if: :image_url
    super(resource, options)
  end
end