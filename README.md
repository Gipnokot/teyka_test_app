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

```bash
curl -X POST http://localhost:9292/operation \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": 1,
    "positions":[
      {"id": 2, "price": 50, "quantity": 2},
      {"id": 3, "price": 40, "quantity": 1},
      {"id": 4, "price": 150, "quantity": 2}
    ]
  }'```bash
Ответ:
```json
{
  "status": "success",
  "user_info": {
    "id": 1,
    "name": "Иван",
    "loyalty_level": "Bronze"
  },
  "operation_id": 14,
  "total_price": 424.0,
  "bonus_info": {
    "balance": "0.9375e4",
    "available_to_spend": 140.0,
    "cashback_percent": 5.0,
    "cashback_earned": 7.0
  },
  "discount_info": {
    "total_discount": 16.0,
    "discount_percent": 0.0
  },
  "positions": [
    {
      "id": 2,
      "type": "increased_cashback",
      "value": 100.0,
      "discount_percent": 10.0,
      "discount_value": 10.0,
      "cashback_percent": 5.0,
      "cashback_value": 5.0
    },
    {
      "id": 3,
      "type": "discount",
      "value": 40.0,
      "discount_percent": 15.0,
      "discount_value": 6.0,
      "cashback_percent": 5.0,
      "cashback_value": 2.0
    },
    {
      "id": 4,
      "type": "noloyalty",
      "value": 300.0,
      "discount_percent": 0.0,
      "discount_value": 0.0,
      "cashback_percent": 0.0,
      "cashback_value": 0.0
    }
  ]
}


curl -X POST http://localhost:9292/submit \
  -H "Content-Type: application/json" \
  -d '{
    "operation_id": 1, # вставить корректный operation_id из ответа первого запроса
    "write_off": 140.0
  }'
