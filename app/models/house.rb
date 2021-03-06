class House < ApplicationRecord
  default_scope { where wizard_complete: true }
  scope :wizard_not_completed_only, -> { unscope(where: :wizard_complete).where(wizard_complete: false) }

  belongs_to :user
  enum form_steps: {
    address_info: [:address, :current_family_last_name],
    house_info: [:interior_color, :exterior_color],
    conditional_page: [],
    house_stats: [:rooms, :square_feet]
  }
  attr_accessor :form_step

	with_options if: -> { required_for_step?(:address_info) } do
	 # validates :address, presence: true, length: { minimum: 10, maximum: 50}
	 # validates :current_family_last_name, presence: true, length: { minimum: 2, maximum: 30}
	end

	with_options if: -> { required_for_step?(:house_info) } do
	 # validates :interior_color, length: { minimum: 2, maximum: 50}
	 # validates :exterior_color, presence: true
	end

	with_options if: -> { required_for_step?(:house_stats) } do
	 # validates :rooms, presence: true, numericality: { gt: 1 }
	 # validates :square_feet, presence: true
	end

  def required_for_step?(step)
    # All fields are required if no form step is present
    return true if form_step.nil?
  
    # All fields from previous steps are required
    ordered_keys = self.class.form_steps.keys.map(&:to_sym)
    !!(ordered_keys.index(step) <= ordered_keys.index(form_step))
  end

  def current_step
    @current_step ||= self.class.form_steps.keys.map(&:to_sym).find do |step|
      self.form_step = step
      step unless valid?
    end
  end
  
end