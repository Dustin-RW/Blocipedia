class ChargesController < ApplicationController

    before_action :require_sign_in

    def new
        @stripe_btn_data = {
            key: Rails.configuration.stripe[:publishable_key].to_s,
            description: "BigMoney Membership - #{current_user.email}",
            amount: 10
        }
    end

    def create
      @amount = 500

      customer = Stripe::Customer.create(
          email: current_user.email,
          source: params[:stripeToken]
      )

      charge = Stripe::Charge.create(
          customer: customer.id,
          amount: @amount,
          description: "BigMoney Membership - #{current_user.email}",
          currency: 'usd'
      )

      current_user.update_attribute(:role, 'premium')

      if current_user.save!
          flash[:notice] = "Thanks for all the money, #{current_user.email}! changed to premium member, #{current_user.role}"
          redirect_to wikis_path # or wherever
      end

      # Stripe will send back CardErrors, with friendly messages
      # when something goes wrong.
      # This `rescue block` catches and displays those errors.
      rescue Stripe::CardError => e
          flash[:alert] = e.message
          redirect_to new_charge_path
      end
end
