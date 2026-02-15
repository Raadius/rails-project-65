# frozen_string_literal: true

def create_bulletin(attrs)
  bulletin = Bulletin.new(attrs)
  bulletin.image.attach(
    io: Rails.root.join('app/assets/images/default-image.png').open,
    filename: 'placeholder.png',
    content_type: 'image/png'
  )
  bulletin.save!
  bulletin
rescue ActiveRecord::RecordInvalid => e
  Rails.logger.debug { "ОШИБКА: #{e.message}" }
  Rails.logger.debug { "Атрибуты: #{attrs.inspect}" }
  Rails.logger.debug { "Ошибки валидации: #{bulletin.errors.full_messages}" }
  raise
end

def attach_placeholder_image(bulletin)
  unless bulletin.image.attached?
    bulletin.image.attach(
      io: Rails.root.join("app/assets/images/default-image.png").open,
      filename: 'placeholder.png',
      content_type: 'image/png'
    )
  end
end

admin = User.find_or_create_by!(email: 'raadius@yandex.ru') do |user|
  user.name = 'Admin'
  user.admin = true
end

user1 = User.find_or_create_by!(email: 'user1@example.com') do |user|
  user.name = Faker::Name.name
end

user2 = User.find_or_create_by!(email: 'user2@example.com') do |user|
  user.name = Faker::Name.name
  user.admin = true
end

categories = %w[Электроника Авто Недвижимость Одежда Спорт].map do |name|
  Category.find_or_create_by!(name: name)
end

3.times do
  create_bulletin(
    title: Faker::Commerce.product_name.truncate(50),
    description: Faker::Lorem.paragraph(sentence_count: 5),
    category: categories.sample,
    user: [user1, user2].sample,
    state: 'published'
  )
end

[user1, user2].each do |user|
  2.times do
    create_bulletin(
      title: Faker::Commerce.product_name.truncate(50),
      description: Faker::Lorem.paragraph(sentence_count: 3),
      category: categories.sample,
      user: user,
      state: 'draft'
    )
  end
end

10.times do
  create_bulletin(
    title: Faker::Commerce.product_name.truncate(50),
    description: Faker::Lorem.paragraph(sentence_count: 4),
    category: categories.sample,
    user: [user1, user2, admin].sample,
    state: 'under_moderation'
  )
end
