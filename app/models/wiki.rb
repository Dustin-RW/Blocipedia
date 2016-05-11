class Wiki < ActiveRecord::Base
  belongs_to :user

  has_many :collaborations, dependent: :destroy
  has_many :users, through: :collaborations


end
