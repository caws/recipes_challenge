class Direction < ApplicationRecord
  belongs_to :recipe, optional: :true

  validates_presence_of :step,
                        :description

  validates_numericality_of :step
end
