# encoding: UTF-8

Admin.create(email: 'admin@example.com', password: 'password') if Admin.count.zero?

if Contestant.count.zero?
  Contestant.create id: 1, name: 'Laís'
  Contestant.create id: 2, name: 'Yuri'
end
