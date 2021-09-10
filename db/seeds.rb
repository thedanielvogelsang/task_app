# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create(
  email: 'dr.vogelsang26@gmail.com',
  user_role: 2
)

User.create(
  email: 'another_user@gmail.com',
  user_role: 0
)

UserAuthentication.create(
  user_id: User.first.id,
  password: 'Changeme!',
  password_confirmation: 'Changeme!'
)

UserAuthentication.create(
  user_id: User.last.id,
  password: 'Changeme!',
  password_confirmation: 'Changeme!'
)

%w[BigPharma Johnson&Johnson UnitedHealth GenericsRUs Sudafed].each do |c|
  Customer.create(name: c)
end

10.times do |i|
  proj = Project.create(
    name: "LEVEL-#{i}",
    customer: Customer.find_by(id: rand(1..Customer.count))
  )
  3.times do |t|
    Task.create(
      project_id: proj.id,
      description: "#{t}: This task is intended to help with #{proj.name} no.#{t}"
    )
  end
end
