if Rails.env.development?
  User.create!(email: "test@example.com",
               password: "test",
               password_confirmation: "test")
end
