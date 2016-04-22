# Store the environment variables on the Rails.configuration object
 Rails.configuration.stripe = {
   publishable_key: ENV['PUBLISHABLE_KEY'],
   secret_key: ENV['SECRET_KEY']
 }

 # Set our app-stored secret key with Stripe
 Stripe.api_key = Rails.configuration.stripe[:secret_key]
 STRIPE_PUBLIC_KEY = Rails.configuration.stripe[:publishable_key]
