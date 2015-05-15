# encoding: UTF-8

if Admin.count.zero?
  Admin.create email: 'admin@example.com', password: 'password'
end

if Contestant.count.zero?
  Contestant.create id: 1, name: 'Laís', avatar: File.open(Rails.root.join 'avatar-lais.png')
  Contestant.create id: 2, name: 'Yuri', avatar: File.open(Rails.root.join 'avatar-yuri.png')
end
