class Climb < ActiveRecord::Base
	belongs_to :user
	default_scope -> { order('created_at DESC') }
	validates :content, presence: true, length: { maximum: 140 }
	validates :grade, presence: true, :numericality => { only_integer: true, greater_than: 0, less_than: 39 }
	validates :user_id, presence: true
end
