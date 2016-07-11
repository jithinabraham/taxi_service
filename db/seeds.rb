#create admin user

User.create!(name:'admin',email:'admin@example.com',password:'admin123',password_confirmation:'admin123',role:'admin') if !(User.count > 1)