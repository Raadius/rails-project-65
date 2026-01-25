# План: Добавление админ-панели для управления контентом

## Текущее состояние проекта

- **User модель**: `name`, `email` — атрибута `admin` нет
- **Pundit**: не установлен
- **Маршруты**: `scope module: :web`, нет `namespace :admin`
- **Policies**: директория `app/policies/` отсутствует
- **Шаблоны**: Slim (`.html.slim`)
- **Локализация**: ru (default), en

---

## Этапы реализации

### 1. Добавить gem `pundit`

**Файл:** `Gemfile`

```ruby
gem 'pundit'
```

**Почему:**
- Pundit — стандартный гем для авторизации в Rails
- Простая интеграция, convention over configuration
- Использует policy-классы, что соответствует принципам Rails

---

### 2. Миграция для атрибута `admin`
сделать миграцию `bin/rails generate migration AddAdminToUsers admin:boolean`.

**Файл:** `db/migrate/XXXXXX_add_admin_to_users.rb`

```ruby
class AddAdminToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :admin, :boolean, default: false, null: false
  end
end
```

**Почему:**
- `default: false` — новые пользователи не админы по умолчанию
- `null: false` — гарантирует наличие значения
- Rails автоматически создаёт метод `admin?` для boolean

---

### 3. Создание админа через seeds

**Файл:** `db/seeds.rb`

```ruby
User.find_or_create_by!(email: 'raadius@yandex.ru') do |user|
  user.name = 'Admin'
  user.admin = true
end
```

**Почему seeds:**
- Создаём пользователя для эталонного/демо проекта
- `find_or_create_by!` — идемпотентность (можно запускать многократно)
- Seeds удобны для начальных данных демо-проекта

---

### 4. Создать policies

**Файл:** `app/policies/application_policy.rb`

Базовая политика с методом `admin?` для проверки прав.

**Файлы:**
- `app/policies/bulletin_policy.rb`
- `app/policies/category_policy.rb`

**Почему наследование:**
- DRY — логика проверки `admin?` в одном месте
- Легко расширить для отдельных ресурсов

---

### 5. Маршруты админ-панели

**Файл:** `config/routes.rb`

```ruby
namespace :admin do
  root 'home#index'
  resources :categories
  resources :bulletins
end
```

**Почему `namespace`, а не `scope`:**
- Отдельные контроллеры в `app/controllers/admin/`
- Чёткое разделение публичной части и админки
- URL вида `/admin/categories`

---

### 6. Контроллеры админки

**Файлы:**
- `app/controllers/admin/application_controller.rb` — базовый с проверками
- `app/controllers/admin/home_controller.rb` — дашборд
- `app/controllers/admin/categories_controller.rb` — CRUD категорий
- `app/controllers/admin/bulletins_controller.rb` — CRUD объявлений

**Почему отдельный `Admin::ApplicationController`:**
- Централизованная проверка аутентификации и авторизации
- `before_action` применяется ко всем действиям админки
- Обработка `Pundit::NotAuthorizedError`

---

### 7. Views для админки

**Директории:**
- `app/views/admin/home/`
- `app/views/admin/categories/`
- `app/views/admin/bulletins/`

**Файлы:**
- index, new, edit, _form для категорий
- index, edit, _form для объявлений
- index для home (дашборд)

---

### 8. Обновить навигацию

**Файл:** `app/views/layouts/shared/_header.html.slim`

Добавить ссылку на админку (видна только админам).

---

### 9. Локализации

**Файлы:** `config/locales/ru.yml`, `config/locales/en.yml`

Добавить переводы для:
- Навигации (navbar.admin)
- Админ-панели (admin.home, admin.categories, admin.bulletins)
- Уведомлений (notices.categories)

---

### 10. Фикстуры

**Файл:** `test/fixtures/users.yml`

```yaml
one:
  name: Regular User
  email: user@example.com
  admin: false

two:
  name: Admin User
  email: admin@example.com
  admin: true
```

---

## Порядок выполнения

1. `gem 'pundit'` в Gemfile → `bundle install`
2. Миграция `add_admin_to_users` → `rails db:migrate`
3. Обновить `db/seeds.rb` — создание админа
4. Создать `app/policies/` с политиками
5. Обновить `config/routes.rb`
6. Создать `app/controllers/admin/`
7. Создать `app/views/admin/`
8. Обновить `_header.html.slim`
9. Обновить локализации
10. Обновить фикстуры
11. `rails db:seed` — создать админа в базе

---

## Верификация

```bash
# Проверка атрибута admin
rails console
> user = User.first
> user.admin? # false
> user.admin = true
> user.save!
> user.admin? # true

# Проверка маршрутов
rails routes | grep admin

# Тесты
rails test

# Линтеры
rubocop
slim-lint app/views/
```

---

## Файлы для создания/изменения

| Файл | Действие |
|------|----------|
| `Gemfile` | Изменить (добавить pundit) |
| `db/migrate/XXX_add_admin_to_users.rb` | Создать |
| `db/seeds.rb` | Изменить (создание админа) |
| `app/policies/application_policy.rb` | Создать |
| `app/policies/bulletin_policy.rb` | Создать |
| `app/policies/category_policy.rb` | Создать |
| `config/routes.rb` | Изменить |
| `app/controllers/admin/application_controller.rb` | Создать |
| `app/controllers/admin/home_controller.rb` | Создать |
| `app/controllers/admin/categories_controller.rb` | Создать |
| `app/controllers/admin/bulletins_controller.rb` | Создать |
| `app/views/admin/home/index.html.slim` | Создать |
| `app/views/admin/categories/*.html.slim` | Создать |
| `app/views/admin/bulletins/*.html.slim` | Создать |
| `app/views/layouts/shared/_header.html.slim` | Изменить |
| `config/locales/ru.yml` | Изменить |
| `config/locales/en.yml` | Изменить |
| `test/fixtures/users.yml` | Изменить |
