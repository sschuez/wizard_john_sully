module StepsControllers
  class HouseStepsController < ApplicationController
    include Wicked::Wizard

    steps *House.form_steps.keys

    def show
      # @house = House.find(params[:house_id])
      @house = House.wizard_not_completed_only.find(params[:house_id])
      case step
      when :address_info
      when :house_info
        # if @house.address == 'green'
        #   jump_to(:house_stats, foo: "bar")
        # end
        # render_wizard @house
      when :conditional_page
      when :house_stats
      end
      render_wizard
    end

    def update
      # @house = House.find(params[:house_id])
      @house = House.wizard_not_completed_only.find(params[:house_id])
      # Use #assign_attributes since render_wizard runs a #save for us
      @house.assign_attributes house_params
      if @house.valid?
        render_wizard @house
      else
        render_wizard @house, status: :unprocessable_entity
      end
    end

    private

    # Only allow the params for specific attributes allowed in this step
    def house_params
      params.require(:house).permit(House.form_steps[step]).merge(form_step: step.to_sym)
    end

    def finish_wizard_path
      @house.update! wizard_complete: true
      house_path(@house)
    end
  end
end