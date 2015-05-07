Recaptcha.configure do |config|
  if Rails.env.production?
    config.public_key  = ENV['RECAPTCHA_PUBLIC_KEY']
    config.private_key = ENV['RECAPTCHA_PRIVATE_KEY']
  else
    config.public_key  = '6LfC1vsSAAAAAHDZ95yuJcS1V4tJvKu5lc804LfI'
    config.private_key = '6LfC1vsSAAAAAO4zxT09bUoghZRljmpsnNKzXVh6'
  end
end