class User < ApplicationRecord
	validates :phone_number, :numericality => {:only_integer => true}
end
