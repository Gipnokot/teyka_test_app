Решение тестового задания Тейка

Требования:
- Ruby 3.0 или выше
- SQLite3
- Bundler (gem install bundler)

Установка:
1) Склонировать репозитории - https://github.com/Gipnokot/teyka_test_app.git
2) cd teyka_test_app
3) установить зависимости - bundle install
4) БД предоставлена для решения тестового, чувствительные данные не загружены в этот репозитории
5) Запуск приложения командой: rackup
6) Запуск тестов командой: RACK_ENV=test rspec

Примеры запросов:

<pre lang="markdown"> ```bash curl -X POST http://localhost:9292/operation \ -H "Content-Type: application/json" \ -d '{ "user_id": 1, "positions": [ {"id": 2, "price": 50, "quantity": 2}, {"id": 3, "price": 40, "quantity": 1}, {"id": 4, "price": 150, "quantity": 2} ] }' ``` </pre>

curl -X POST http://localhost:9292/submit \
  -H "Content-Type: application/json" \
  -d '{
    "operation_id": 1, # вставить корректный operation_id из ответа первого запроса
    "write_off": 140.0
  }'
