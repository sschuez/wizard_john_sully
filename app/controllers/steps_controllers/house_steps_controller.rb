module StepsControllers
  class HouseStepsController < ApplicationController
    include Wicked::Wizard

    steps *House.form_steps.keys

    def show
      @house = House.find(params[:house_id])
      render_wizard
    end

    def update
      @house = House.find(params[:house_id])
      # Use #assign_attributes since render_wizard runs a #save for us
      @house.assign_attributes house_params
      render_wizard @house
    end

    private

    # Only allow the params for specific attributes allowed in this step
    def house_params
      params.require(:house).permit(House.form_steps[step]).merge(form_step: step.to_sym)
    end

    def finish_wizard_path
      house_path(@house)
    end
  end
end