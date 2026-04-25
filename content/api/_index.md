---
title: API awg‑manager
weight: 6
---

Полная справка по REST API awg‑manager. Описаны все эндпоинты, аутентификация, форматы запросов и ответов. Для общего знакомства смотрите [Быстрый старт](../quickstart/), а примеры использования конкретных функций — [Руководство](../guide/).

## Общие сведения

- **Базовый URL:** `http://<router-ip>:<port>/api` (порт по умолчанию 2222, выбирается динамически)
- **Аутентификация:** сессионная cookie `awg_session`. Большинство эндпоинтов требуют валидной сессии. Публичные (без аутентификации):  
  `/auth/login`, `/auth/logout`, `/auth/status`, `/health`, `/hook/ndms`, `/dns-check/probe`, `/boot-status`
- **Формат ответа (успех):**
  ```json
  { "success": true, "data": { ... } }
  ```
- **Формат ответа (ошибка):**
  ```json
  { "success": false, "error": "сообщение", "code": "ERROR_CODE" }
  ```
- **Коды ошибок (неполный список):**
  - `METHOD_NOT_ALLOWED` — неверный HTTP метод
  - `MISSING_NAME`, `MISSING_ID`, `MISSING_MAC` и т.п.
  - `INVALID_NAME`, `INVALID_ID`, `INVALID_JSON`
  - `NOT_FOUND` — ресурс не найден
  - `UNAUTHORIZED` — требуется аутентификация
  - `AUTH_FAILED` — неверные учётные данные
  - `ROUTER_UNAVAILABLE` — нет связи с роутером
  - `CREATE_FAILED`, `UPDATE_FAILED`, `DELETE_FAILED`, `LIST_FAILED`
  - `INTERNAL_ERROR` — внутренняя ошибка сервера

{{< callout type="warning" >}}
Эндпоинты, возвращающие `405 Method Not Allowed`, могут использовать сокращённый формат `{ "error": true, "message": "...", "code": "METHOD_NOT_ALLOWED" }`. Клиентам следует обрабатывать оба варианта.
{{< /callout >}}

## Аутентификация

| Метод | Путь | Описание | Доступ |
|-------|------|----------|--------|
| POST | `/auth/login` | Вход (устанавливает cookie `awg_session`) | public |
| POST | `/auth/logout` | Выход (удаляет cookie) | public (требует наличия cookie) |
| GET | `/auth/status` | Статус текущей сессии | public (с cookie) |

### POST `/auth/login`
**Тело:**
```json
{ "login": "admin", "password": "secret" }
```
**Успех (200):** `{ "success": true, "login": "admin" }`  
**Ошибки:**  
- `AUTH_FAILED` (401) – неверный логин/пароль  
- `ROUTER_UNAVAILABLE` (503) – роутер недоступен  

### GET `/auth/status`
**Успех (200):**  
Если аутентификация включена и сессия валидна:
```json
{ "authenticated": true, "login": "admin", "expiresIn": 3540 }
```
Если сессии нет:
```json
{ "authenticated": false }
```
Если аутентификация отключена глобально (в настройках):
```json
{ "authenticated": true, "authDisabled": true }
```

### POST `/auth/logout`
**Успех (200):** `{ "success": true }`

## Health и boot

| Метод | Путь | Описание | Доступ |
|-------|------|----------|--------|
| GET | `/health` | Проверка живости сервера, возвращает версию | public |
| GET | `/boot-status` | Статус инициализации (instanceId, phase) | public |

### GET `/health`
```json
{ "success": true, "data": { "ok": true, "version": "2.8.0" } }
```

### GET `/boot-status`
```json
{
  "initializing": false,
  "remainingSeconds": 0,
  "phase": "ready",
  "instanceId": "a1b2c3..."
}
```

## Система

| Метод | Путь | Описание | Аутентификация |
|-------|------|----------|----------------|
| GET | `/system/info` | Полная информация о системе, прошивке, бэкендах | да |
| POST | `/system/restart` | Перезапуск демона awg‑manager (с задержкой) | да |
| GET | `/system/wan-interfaces` | Список WAN‑интерфейсов (ядро) | да |
| GET | `/system/all-interfaces` | Все сетевые интерфейсы роутера (через NDMS) | да |
| GET | `/system/hydraroute-status` | Статус установки HydraRoute Neo | да |
| POST | `/system/hydraroute-control` | Управление HydraRoute (start/stop/restart) | да |

### GET `/system/info`
Возвращает объект (пример):
```json
{
  "version": "2.8.0",
  "goVersion": "go1.22.0",
  "goArch": "arm",
  "keeneticOS": "KeeneticOS 5.0",
  "isOS5": true,
  "firmwareVersion": "5.0.1",
  "supportsExtendedASC": true,
  "supportsHRanges": true,
  "supportsPingCheck": true,
  "totalMemoryMB": 1024,
  "isLowMemory": false,
  "gcMemLimit": "512MiB",
  "gogc": "100",
  "disableMemorySaving": false,
  "kernelModuleExists": true,
  "kernelModuleLoaded": true,
  "kernelModuleModel": "MT7621",
  "kernelModuleVersion": "1.0",
  "isAarch64": false,
  "activeBackend": "kernel",
  "routerIP": "192.168.1.1",
  "bootInProgress": false,
  "backendAvailability": {
    "nativewg": true,
    "kernel": true
  },
  "singbox": {
    "installed": true,
    "version": "v1.8.0"
  }
}
```

### GET `/system/wan-interfaces`
```json
[
  { "name": "ppp0", "label": "PPPoE", "state": "up" },
  { "name": "eth3", "label": "WAN", "state": "down" }
]
```

### GET `/system/all-interfaces`
Массив интерфейсов с полями `name`, `label`, `type` и т.д. (зависит от NDMS).

### POST `/system/hydraroute-control`
**Тело:** `{ "action": "start" | "stop" | "restart" }`  
**Ответ:** статус после выполнения (как в `GET /system/hydraroute-status`).

## Настройки приложения

| Метод | Путь | Описание | Аутентификация |
|-------|------|----------|----------------|
| GET | `/settings/get` | Получить все настройки (порт, auth, etc.) | да |
| POST | `/settings/update` | Сохранить настройки (полный объект) | да |

**Пример ответа `GET /settings/get`:**
```json
{
  "port": 2222,
  "authEnabled": true,
  "sessionTTLSeconds": 3600,
  "disableMemorySaving": false,
  "serverInterfaces": ["Wireguard0"],
  "hiddenSystemTunnels": ["Wireguard2"],
  "managedServer": { ... }
}
```
При обновлении передаётся аналогичный объект.

## Обновления

| Метод | Путь | Описание | Аутентификация |
|-------|------|----------|----------------|
| GET | `/system/update/check` | Проверить наличие новой версии (кеш) | да |
| GET | `/system/update/check?force=true` | Принудительная проверка | да |
| POST | `/system/update/apply` | Запустить обновление через opkg | да |
| GET | `/system/update/changelog` | Получить список изменений (от `from` до `to`) | да |

### GET `/system/update/changelog`
Параметры:
- `from` (опционально) – версия, начиная с которой показывать изменения
- `to` (обязательно) – целевая версия

Если `from` не указан, возвращается запись для версии `to`.  
**Ответ:** `{ "entries": [ { "version": "2.8.0", "changes": [...] } ] }`

## NDMS save‑status

| Метод | Путь | Описание | Аутентификация |
|-------|------|----------|----------------|
| GET | `/ndms/save-status` | Текущее состояние debounced‑сохранения конфигурации | да |

**Ответ:**
```json
{
  "state": "idle",      // idle, pending, saving, error, failed
  "lastError": "",
  "lastSaveAt": "2025-01-01T12:00:00Z",
  "pendingCount": 0
}
```

## VPN‑серверы (WireGuard Server Interfaces)

| Метод | Путь | Описание | Аутентификация |
|-------|------|----------|----------------|
| GET | `/servers` | Краткий список серверных интерфейсов (с фильтрацией) | да |
| GET | `/servers/all` | Полный снимок: серверы + managed + WAN IP | да |
| GET | `/servers/get?name=` | Детали одного сервера со списком пиров | да |
| GET | `/servers/config?name=` | Конфигурация в формате RC для генерации `.conf` | да |
| POST | `/servers/mark?name=` | Отметить интерфейс как сервер | да |
| DELETE | `/servers/mark?name=` | Снять отметку (вернуть в системные туннели) | да |
| GET | `/servers/wan-ip` | Внешний WAN IP роутера | да |
| GET | `/servers/marked` | Список ID отмеченных серверных интерфейсов | да |

**Примечание:** Имя должно соответствовать шаблону `WireguardN` (N – число).  
**`POST/DELETE /servers/mark`** возвращают свежий `ServersSnapshot` (как `/servers/all`).  
**Структура `/servers/all`:**
```json
{
  "servers": [...],
  "managed": { ... },        // если создан managed‑сервер
  "managedStats": { ... },   // статистика пиров managed
  "wanIP": "123.45.67.89"
}
```

## Управляемый WireGuard‑сервер

| Метод | Путь | Описание | Аутентификация |
|-------|------|----------|----------------|
| GET | `/managed-server` | Текущая конфигурация сервера (или null) | да |
| GET | `/managed-server/stats` | Статистика пиров (rx/tx, handshake) | да |
| POST | `/managed-server/create` | Создать сервер (задаёт интерфейс) | да |
| PUT | `/managed-server/update` | Изменить адрес/порт | да |
| DELETE | `/managed-server/delete` | Удалить сервер и всех пиров | да |
| POST | `/managed-server/peers` | Добавить пира | да |
| PUT | `/managed-server/peers/update?pubkey=` | Обновить пира | да |
| DELETE | `/managed-server/peers?pubkey=` | Удалить пира | да |
| POST | `/managed-server/peers/toggle` | Вкл/выкл пира | да |
| GET | `/managed-server/peers/conf?pubkey=` | Сгенерировать `.conf` для пира | да |
| POST | `/managed-server/policy` | Установить политику доступа для интерфейса | да |
| GET | `/managed-server/policies` | Список доступных политик (IP Policy) | да |
| POST | `/managed-server/nat` | Включить/отключить NAT на интерфейсе | да |
| POST | `/managed-server/enabled` | Включить/отключить интерфейс | да |
| GET | `/managed-server/asc` | Получить ASC‑параметры (AmneziaWG) | да |
| POST | `/managed-server/asc` | Установить ASC‑параметры (raw JSON) | да |
| GET | `/managed-server/suggest-address` | Предложить свободную частную подсеть /24 | да |

**Пример создания:**
```json
{
  "address": "10.10.0.1",
  "mask": "24",
  "listenPort": 51820,
  "interfaceName": "Wireguard5"   // опционально
}
```
**ASC‑параметры (ответ):**
```json
{
  "i1": 0, "i2": 0, "i3": 0, "i4": 0, "i5": 0,
  "jc": 0, "jmin": 0, "jmax": 0,
  "s1": 0, "s2": 0, "s3": 0, "s4": 0,
  "h1": 0, "h2": 0, "h3": 0, "h4": 0
}
```

## Туннели (управляемые)

| Метод | Путь | Описание | Аутентификация |
|-------|------|----------|----------------|
| GET | `/tunnels/list` | Список всех туннелей (сокращённый) | да |
| GET | `/tunnels/all` | Составной снимок (туннели + external + system) | да |
| GET | `/tunnels/get?id=` | Детали одного туннеля | да |
| POST | `/tunnels/create` | Создать туннель | да |
| POST | `/tunnels/update?id=` | Обновить туннель | да |
| POST | `/tunnels/delete?id=` | Удалить туннель | да |
| GET | `/tunnels/traffic?id=&period=1h|24h` | История трафика (точки + статистика) | да |
| GET | `/tunnels/export?id=` | Скачать конфиг `.conf` | да |
| GET | `/tunnels/export-all` | Скачать все конфиги ZIP‑архивом | да |
| POST | `/tunnels/replace` | Заменить конфигурацию из нового `.conf` | да |
| POST | `/import/conf` | Импорт из конфига (имя, backend) | да |

### GET `/tunnels/list` – ответ
```json
[
  {
    "id": "my-tunnel",
    "name": "My Tunnel",
    "type": "awg",
    "status": "running",
    "enabled": true,
    "defaultRoute": false,
    "ispInterface": "ppp0",
    "ispInterfaceLabel": "PPPoE",
    "resolvedIspInterface": "ppp0",
    "resolvedIspInterfaceLabel": "PPPoE",
    "endpoint": "1.2.3.4:51820",
    "address": "10.0.0.2/24",
    "interfaceName": "awg0",
    "ndmsName": "Wireguard3",
    "hasAddressConflict": false,
    "rxBytes": 1234567,
    "txBytes": 9876543,
    "lastHandshake": "2025-01-01T12:00:00Z",
    "backend": "kernel",
    "backendType": "AmneziaWG",
    "awgVersion": "amneziawg",
    "mtu": 1420,
    "startedAt": "2025-01-01T11:00:00Z",
    "pingCheck": { "status": "alive", "enabled": true, "method": "icmp" }
  }
]
```

### GET `/tunnels/all` – ответ
```json
{
  "tunnels": [ ... ],   // те же элементы, что в /tunnels/list
  "external": [ ... ],  // внешние туннели (см. раздел "Внешние туннели")
  "system": [ ... ]     // системные туннели (см. раздел "Системные туннели")
}
```

### POST `/tunnels/create`
Тело – объект `AWGTunnel` (минимально: `name`, `interface`, `peer`). ID генерируется автоматически.
**Ответ:** созданный туннель (как в `GET /tunnels/get`).

### POST `/tunnels/update?id=`
Тело – частичное обновление (только изменяемые поля).  
**Ответ:** обновлённый туннель + поле `warnings` (при конфликтах адресов).

### POST `/tunnels/replace?id=`
```json
{ "content": "новый конфиг", "name": "новое имя" }
```
Если туннель запущен, он будет остановлен перед заменой и перезапущен.

## Управление туннелями (Start/Stop)

| Метод | Путь | Описание | Аутентификация |
|-------|------|----------|----------------|
| POST | `/control/start?id=` | Запустить туннель | да |
| POST | `/control/stop?id=` | Остановить туннель | да |
| POST | `/control/restart?id=` | Перезапустить туннель | да |
| POST | `/control/restart-all` | Перезапустить все включённые туннели | да |
| POST | `/control/toggle-enabled?id=` | Переключить флаг `enabled` (автозапуск) | да |
| POST | `/control/toggle-default-route?id=` | Переключить маршрут по умолчанию | да |

Все эндпоинты возвращают обновлённый туннель (как в `GET /tunnels/get?id=`).

## Статус туннелей

| Метод | Путь | Описание | Аутентификация |
|-------|------|----------|----------------|
| GET | `/status/get?tunnel=` | Получить состояние одного туннеля (runtime) | да |
| GET | `/status/all` | Состояние всех туннелей | да |

Отличаются облегчённой структурой (только статус, счётчики). Используются внутри orchestrator.

## Ping‑check мониторинг

| Метод | Путь | Описание | Аутентификация |
|-------|------|----------|----------------|
| GET | `/pingcheck/status` | Статус мониторинга всех туннелей (вкл/выкл, результаты) | да |
| GET | `/pingcheck/logs` | Логи проверок (с фильтром `?tunnelId=`) | да |
| POST | `/pingcheck/logs/clear` | Очистить все логи | да |
| POST | `/pingcheck/check-now` | Запустить немедленную проверку всех туннелей | да |
| GET | `/tunnels/pingcheck?id=` | Получить конфигурацию ping‑check для туннеля | да |
| POST | `/tunnels/pingcheck?id=` | Создать/обновить ping‑check для туннеля | да |
| POST | `/tunnels/pingcheck/remove?id=` | Удалить ping‑check для туннеля | да |

**Конфигурация ping‑check (тело POST):**
```json
{
  "host": "8.8.8.8",
  "mode": "icmp",          // icmp, connect, tls
  "updateInterval": 45,
  "maxFails": 3,
  "minSuccess": 1,
  "timeout": 5,
  "restart": true,
  "port": 0
}
```

**GET `/pingcheck/status` ответ:**
```json
{
  "enabled": true,
  "tunnels": [
    {
      "tunnelId": "my-tunnel",
      "tunnelName": "My Tunnel",
      "enabled": true,
      "status": "alive",
      "method": "icmp",
      "lastCheck": "2025-01-01T12:00:00Z",
      "failCount": 0
    }
  ]
}
```

## Внешние туннели (неуправляемые)

| Метод | Путь | Описание | Аутентификация |
|-------|------|----------|----------------|
| GET | `/external-tunnels` | Список WireGuard‑туннелей, не созданных менеджером | да |
| POST | `/external-tunnels/adopt?interface=` | Принять внешний туннель под управление | да |

**GET `/external-tunnels` ответ:**
```json
[
  {
    "interfaceName": "opkgtun5",
    "tunnelNumber": 5,
    "isAWG": true,
    "publicKey": "...",
    "endpoint": "1.2.3.4:51820",
    "lastHandshake": "2025-01-01T12:00:00Z",
    "rxBytes": 123,
    "txBytes": 456
  }
]
```

**POST `/external-tunnels/adopt?interface=opkgtun5`**  
Тело: `{ "content": "полный конфиг", "name": "желаемое имя" }`  
Ответ: созданный туннель (аналогично `/tunnels/get?id=`).

## Системные туннели (нативные Keenetic)

| Метод | Путь | Описание | Аутентификация |
|-------|------|----------|----------------|
| GET | `/system-tunnels` | Список видимых (не скрытых) системных туннелей | да |
| GET | `/system-tunnels/get?name=` | Детали одного туннеля | да |
| GET | `/system-tunnels/asc?name=` | Получить ASC‑параметры | да |
| POST | `/system-tunnels/asc?name=` | Установить ASC‑параметры (raw JSON) | да |
| GET | `/system-tunnels/test-connectivity?name=` | Проверить связность через туннель | да |
| GET | `/system-tunnels/test-ip?name=&service=` | Проверить внешний IP через туннель | да |
| GET | `/system-tunnels/test-speed?name=&server=&port=&direction=` | Тест скорости (SSE) | да |
| POST | `/system-tunnels/hide?name=` | Скрыть туннель из списка | да |
| DELETE | `/system-tunnels/hide?name=` | Показать туннель (убрать из скрытых) | да |
| GET | `/system-tunnels/hidden` | Список ID скрытых туннелей | да |

**Примечание:** Имя должно быть `WireguardN`.

## Политики доступа (Access Policies) – **только OS5**

| Метод | Путь | Описание | Аутентификация |
|-------|------|----------|----------------|
| GET | `/access-policies` | Список политик (плюс количество устройств) | да |
| POST | `/access-policies/create` | Создать новую политику | да |
| DELETE | `/access-policies/delete?name=` | Удалить политику | да |
| POST | `/access-policies/description` | Обновить описание политики | да |
| POST | `/access-policies/standalone` | Включить/выключить standalone режим | да |
| POST | `/access-policies/permit` | Разрешить интерфейс на политике (с порядком) | да |
| DELETE | `/access-policies/permit?name=&interface=` | Запретить интерфейс | да |
| POST | `/access-policies/assign` | Назначить устройство политике | да |
| DELETE | `/access-policies/assign?mac=` | Отвязать устройство | да |
| GET | `/access-policies/devices` | Список LAN‑устройств с назначенными политиками | да |
| GET | `/access-policies/interfaces` | Список интерфейсов, доступных для policy routing | да |
| POST | `/access-policies/interface-up` | Поднять/опустить интерфейс | да |

**Параметр `?refresh=true`** для `GET /access-policies` и `GET /access-policies/devices` – принудительно сбрасывает кэш NDMS.

**Пример создания политики:**
```json
{ "description": "My Policy" }
```
Ответ: `{ "name": "Policy0" }`.

**Пример назначения устройства:**
```json
{ "mac": "AA:BB:CC:DD:EE:FF", "policy": "Policy0" }
```

**Пример разрешения интерфейса:**
```json
{ "name": "Policy0", "interface": "Wireguard0", "order": 0 }
```

**Поднять/опустить интерфейс:**
```json
{ "name": "Wireguard0", "up": true }
```

## DNS‑маршруты

| Метод | Путь | Описание | Аутентификация |
|-------|------|----------|----------------|
| GET | `/dns-routes/list` | Список всех DNS‑маршрутов (доменных списков) | да |
| GET | `/dns-routes/get?id=` | Получить один список | да |
| POST | `/dns-routes/create` | Создать список | да |
| POST | `/dns-routes/update?id=` | Обновить список | да |
| POST | `/dns-routes/delete?id=` | Удалить список | да |
| POST | `/dns-routes/delete-batch` | Удалить несколько списков по ID | да |
| POST | `/dns-routes/create-batch` | Создать несколько списков | да |
| POST | `/dns-routes/set-enabled?id=` | Включить/отключить список | да |
| POST | `/dns-routes/bulk-backend` | Сменить бэкенд для нескольких списков | да |
| POST | `/dns-routes/refresh` | Обновить подписки (все или по ID) | да |

**Структура DNS‑маршрута:**
```json
{
  "id": "dns-1",
  "name": "My Domains",
  "domains": ["example.com", "domain.org"],
  "enabled": true,
  "backend": "ndms",       // ndms, hydraroute или static
  "subscriptionURL": "",
  "lastUpdate": ""
}
```

**Пример создания:**
```json
{
  "name": "My Domains",
  "domains": ["example.com"],
  "backend": "ndms"
}
```

**Bulk backend:**
```json
{ "listIDs": ["id1","id2"], "backend": "hydraroute" }
```

## Статические маршруты

| Метод | Путь | Описание | Аутентификация |
|-------|------|----------|----------------|
| GET | `/static-routes/list` | Список списков статических маршрутов | да |
| POST | `/static-routes/create` | Создать новый список | да |
| POST | `/static-routes/update` | Обновить существующий список | да |
| POST | `/static-routes/delete?id=` | Удалить список | да |
| POST | `/static-routes/set-enabled?id=` | Включить/отключить список | да |
| POST | `/static-routes/import` | Импортировать подсети из `.bat` файла | да |

**Структура:**
```json
{
  "id": "static-1",
  "name": "Route List",
  "subnets": ["192.168.2.0/24", "10.0.0.0/16"],
  "enabled": true,
  "tunnelID": "my-tunnel"
}
```

**Импорт:**
```json
{
  "tunnelID": "my-tunnel",
  "name": "Imported Routes",
  "content": "route add ...\nroute add ..."
}
```

## Клиентские маршруты

| Метод | Путь | Описание | Аутентификация |
|-------|------|----------|----------------|
| GET | `/client-routes` | Список клиентских маршрутов (device → tunnel) | да |
| POST | `/client-routes/create` | Создать маршрут | да |
| POST | `/client-routes/update?id=` | Обновить | да |
| POST | `/client-routes/delete?id=` | Удалить | да |
| POST | `/client-routes/toggle?id=` | Включить/отключить | да |

**Структура:**
```json
{
  "id": "cr-1",
  "clientIP": "192.168.1.100",
  "tunnelID": "my-tunnel",
  "enabled": true
}
```

## WAN статус

| Метод | Путь | Описание | Аутентификация |
|-------|------|----------|----------------|
| GET | `/wan/status` | Текущий статус WAN‑интерфейсов | да |

**Ответ:**
```json
{
  "interfaces": {
    "ppp0": { "up": true, "label": "PPPoE" },
    "eth3": { "up": false, "label": "WAN" }
  },
  "anyWANUp": true
}
```

## Соединения (conntrack)

| Метод | Путь | Описание | Аутентификация |
|-------|------|----------|----------------|
| GET | `/connections` | Список активных соединений (фильтрация, пагинация) | да |

**Параметры:**
- `tunnel` – имя туннеля (интерфейс)
- `protocol` – tcp/udp/icmp
- `search` – поиск по IP или порту
- `sortBy` – поле сортировки (например, `rxBytes`)
- `sortDir` – `asc` или `desc`
- `offset` – сдвиг (постранично)
- `limit` – количество записей на страницу (максимум 1000, иначе обрезается)

**Ответ:**
```json
{
  "total": 42,
  "connections": [
    {
      "srcIP": "192.168.1.100",
      "srcPort": 12345,
      "dstIP": "8.8.8.8",
      "dstPort": 443,
      "protocol": "tcp",
      "state": "ESTABLISHED",
      "tunnel": "awg0",
      "rxBytes": 1024,
      "txBytes": 2048
    }
  ]
}
```

## Диагностика

| Метод | Путь | Описание | Аутентификация |
|-------|------|----------|----------------|
| POST | `/diagnostics/run` | Запустить фоновую диагностику (сбор отчёта) | да |
| GET | `/diagnostics/status` | Текущий статус выполнения | да |
| GET | `/diagnostics/result` | Скачать последний отчёт (JSON, attachment) | да |
| GET | `/diagnostics/stream` | SSE‑поток прогресса диагностики | да |

**Параметры `/diagnostics/stream`:**
- `mode=quick|full` (по умолчанию quick)
- `restart=true` – перезапускать ли sing‑box при измерении
- `route=direct|tunnel` – режим маршрутизации для тестов
- `tunnelId=xxx` – ID туннеля при `route=tunnel`

## Логи приложения

| Метод | Путь | Описание | Аутентификация |
|-------|------|----------|----------------|
| GET | `/logs` | Получить записи логов (с фильтрацией) | да |
| POST | `/logs/clear` | Очистить все логи | да |

**Параметры GET:**
- `group` – группа (tunnel, system, routing)
- `subgroup` – подгруппа (lifecycle, settings, dnsroute ...)
- `level` – info, warn, error, debug
- `limit` – количество (default 200)
- `offset` – сдвиг

**Ответ:**
```json
{
  "enabled": true,
  "logs": [
    { "timestamp": "2025-01-01T12:00:00Z", "level": "info", "group": "tunnel", "subgroup": "lifecycle", "message": "Tunnel started" }
  ],
  "total": 1500
}
```

## Тестирование туннелей

| Метод | Путь | Описание | Аутентификация |
|-------|------|----------|----------------|
| GET | `/test/ip?id=&service=` | Проверить внешний IP через туннель | да |
| GET | `/test/ip/services` | Список доступных сервисов проверки IP | да |
| GET | `/test/connectivity?id=` | Проверить связность (ping/http) через туннель | да |
| GET | `/test/speed/servers` | Список предустановленных iperf3‑серверов | да |
| GET | `/test/speed?id=&server=&port=&direction=` | Тест скорости (одно направление, блокирующий) | да |
| GET | `/test/speed/stream?id=&server=&port=&direction=` | SSE‑поток теста скорости (с интервалами) | да |

**Пример ответа `/test/ip`:**
```json
{ "ip": "1.2.3.4", "service": "ipv4.icanhazip.com" }
```
**Пример ответа `/test/connectivity`:**
```json
{ "connected": true, "latency": 42, "reason": "" }
```

## HydraRoute Neo

| Метод | Путь | Описание | Аутентификация |
|-------|------|----------|----------------|
| GET | `/hydraroute/config` | Получить текущую конфигурацию (JSON) | да |
| PUT | `/hydraroute/config/update` | Записать конфигурацию (полный объект) | да |
| GET | `/hydraroute/geo-files` | Список загруженных geo‑файлов | да |
| POST | `/hydraroute/geo-files/add` | Скачать и зарегистрировать geo‑файл (body: {url, path}) | да |
| DELETE | `/hydraroute/geo-files?path=` | Удалить geo‑файл | да |
| POST | `/hydraroute/geo-files/update` | Принудительно обновить geo‑файл(ы) | да |
| GET | `/hydraroute/geo-tags` | Получить полный список тегов всех geo‑файлов | да |
| GET | `/hydraroute/ipset-usage` | Статистика использования ipset | да |
| POST | `/hydraroute/policy-order` | Установить порядок политик | да |
| GET | `/hydraroute/oversized-tags` | Теги, превышающие лимит ipset | да |

## Sing‑box

| Метод | Путь | Описание | Аутентификация |
|-------|------|----------|----------------|
| GET | `/singbox/status` | Статус установки и процесса | да |
| POST | `/singbox/install` | Установить sing‑box (opkg) | да |
| GET | `/singbox/tunnels` | Список туннелей (outbounds) с историей задержек | да |
| POST | `/singbox/tunnels` | Добавить туннели из списка ссылок | да |
| GET | `/singbox/tunnels?tag=` | Получить один outbound (raw JSON) | да |
| PUT | `/singbox/tunnels?tag=` | Обновить outbound (raw JSON) | да |
| DELETE | `/singbox/tunnels?tag=` | Удалить туннель | да |
| POST | `/singbox/tunnels/delay-check?tag=` | Разовая проверка задержки | да |
| GET | `/singbox/tunnels/test/speed/stream?tag=&server=&port=` | Тест скорости через туннель (SSE) | да |
| * | `/singbox/clash/`, `/singbox/clash/*` | Прокси Clash API (HTTP + WebSocket) | да |

**Добавление туннелей:**
```json
{ "links": "vless://...\nhy2://...\ntrojan://..." }
```
**Ответ:** `{ "imported": [...], "errors": [...], "tunnels": [...] }`

**GET `/singbox/tunnels` ответ (enriched):**
```json
[
  {
    "tag": "my-tunnel",
    "type": "vless",
    "server": "example.com",
    "port": 443,
    "connectivity": { "connected": true, "latency": 120 }
  }
]
```

Clash API проксирует все эндпоинты (например, `/proxies`, `/connections`, `/traffic`, `/logs`, `/configs`).

## Device Proxy (SOCKS5/HTTP)

| Метод | Путь | Описание | Аутентификация |
|-------|------|----------|----------------|
| GET | `/proxy/config` | Получить конфигурацию прокси | да |
| PUT | `/proxy/config` | Сохранить конфигурацию и применить | да |
| POST | `/proxy/apply` | Полная перезагрузка sing‑box с текущим конфигом | да |
| GET | `/proxy/runtime` | Текущий выбранный outbound (активный) | да |
| POST | `/proxy/runtime/select` | Переключить outbound на лету | да |
| GET | `/proxy/outbounds` | Список доступных outbound‑тэгов | да |
| GET | `/proxy/listen-choices` | Список интерфейсов и LAN IP для прослушивания | да |

**PUT `/proxy/config` тело:**
```json
{
  "enabled": true,
  "port": 1080,
  "listenAll": true,
  "selectedOutbound": "direct",
  "auth": { "enabled": false, "username": "", "password": "" }
}
```

**POST `/proxy/runtime/select`:**
```json
{ "tag": "my-tunnel" }
```

## Захват сигнатуры

| Метод | Путь | Описание | Аутентификация |
|-------|------|----------|----------------|
| GET | `/signature/capture?domain=` | Получить сигнатуру Keenetic для домена | да |

Используется для обхода прозрачного прокси (AmneziaWG).  
**Ответ:** `{ "signature": "..." }`

## Терминал (ttyd)

| Метод | Путь | Описание | Аутентификация |
|-------|------|----------|----------------|
| GET | `/terminal/status` | Статус установки и запуска ttyd | да |
| POST | `/terminal/install` | Установить ttyd через opkg | да |
| POST | `/terminal/start` | Запустить ttyd (выбрать порт) | да |
| POST | `/terminal/stop` | Остановить ttyd | да |
| GET | `/terminal/ws` | WebSocket‑соединение (прокси на ttyd) | да |

**Статус:**
```json
{ "installed": true, "running": true, "sessionActive": false }
```

**Пример ответа:**

```json
{ "success": false, "error": "Terminal already open in another tab", "code": "SESSION_ACTIVE" }
```

WebSocket требует подпротокола `tty`. При активной сессии другие подключения отклоняются (409 Confict).

## Server‑Sent Events (SSE)

**Endpoint:** `GET /events` (требует аутентификации)  
**Content-Type:** `text/event-stream`

События публикуются в реальном времени. Клиент должен перезапрашивать холодные данные по `resource:invalidated`.

**Типы событий и данные:**

| Тип события | Поля data | Описание |
|-------------|-----------|-----------|
| `connected` | `{"ok":true}` | Начало потока |
| `resource:invalidated` | `{"resource":"tunnels","reason":"create"}` | Клиент должен перезапросить указанный ресурс |
| `tunnel:state` | `{"id":"...","name":"...","state":"running","backend":"kernel"}` | Изменение состояния туннеля |
| `tunnel:deleted` | `{"id":"..."}` | Туннель удалён |
| `connectivity` | Результат проверки связности | (структура не фиксирована) |
| `pingcheck:log` | Запись лога ping‑check | `{...}` |
| `logs` | Запись системного лога | `{...}` |
| `singbox:traffic` | Массив `{tag, upload, download}` | Трафик sing‑box туннелей |
| `singbox:delay` | `{tag, delay, timestamp}` | Результат проверки задержки |
| `deviceproxy:missing-target` | `{tag}` | Выбранный outbound больше не существует |
| `tunnel:traffic` | `{id, rxBytes, txBytes}` | Обновление трафика конкретного туннеля |

**Пример потока:**
```
event: connected
data: {"ok":true}

event: resource:invalidated
data: {"resource":"tunnels","reason":"list-changed"}

event: tunnel:state
data: {"id":"my-tunnel","state":"running","backend":"kernel"}
```

## Унифицированные маршрутизационные ресурсы (polling aliases)

Эти эндпоинты используются фронтендом для опроса (polling) и повторяют данные из соответствующих разделов.

| Метод | Путь | Описание | Аутентификация |
|-------|------|----------|----------------|
| GET | `/routing/tunnels` | Список туннелей для маршрутизации (catalog) | да |
| POST | `/routing/refresh` | Принудительно сбросить кэши NDMS и опубликовать invalidated | да |
| GET | `/routing/resolve?address=` | Разрешить IP/домен через NDMS | да |
| GET | `/routing/dns-routes` | Алиас на `/dns-routes/list` | да |
| GET | `/routing/static-routes` | Алиас на `/static-routes/list` | да |
| GET | `/routing/client-routes` | Алиас на `/client-routes` | да |
| GET | `/routing/policy-devices` | Алиас на `/access-policies/devices` (hotspot) | да |
| GET | `/routing/access-policies` | Список политик (OS5) или [] (OS4) | да |
| GET | `/routing/policy-interfaces` | Список интерфейсов для политик (OS5) или [] (OS4) | да |

**POST `/routing/refresh`** возвращает `{ "missing": [...] }` (список отсутствующих целей).

## Прочие эндпоинты

| Метод | Путь | Описание | Аутентификация |
|-------|------|----------|----------------|
| GET | `/dns-check/start` | Запустить кастомный DNS‑зонд (в фоне) | да |
| GET | `/dns-check/probe` | Endpoint для приёма DNS‑запросов от клиента (CORS, public) | public |
| POST | `/hook/ndms` | Webhook для уведомлений NDMS (ifcreated, ifdestroyed, iflayerchanged) | public |

**POST `/hook/ndms`** принимает form-urlencoded с полями: `type`, `id`, `system_name`, `layer`, `level`, `address`, `up`, `connected`. Используется скриптами NDMS.

## Основные коды ошибок

`METHOD_NOT_ALLOWED`, `UNAUTHORIZED`, `BAD_REQUEST`, `NOT_FOUND`, `INVALID_JSON`, `MISSING_NAME`, `MISSING_ID`, `MISSING_MAC`, `INVALID_NAME`, `INVALID_ID`, `INVALID_ENDPOINT`, `CREATE_FAILED`, `UPDATE_FAILED`, `DELETE_FAILED`, `LIST_FAILED`, `AUTH_FAILED`, `ROUTER_UNAVAILABLE`, `INTERNAL_ERROR`, `CONFLICT`, `SERVICE_UNAVAILABLE`, `NO_STREAMING`, `PINGCHECK_CONFIGURE_ERROR`, `PINGCHECK_REMOVE_ERROR`, `HYDRAROUTE_CONTROL_ERROR`, `GET_ASC_FAILED`, `SET_ASC_FAILED`, `STATIC_ROUTE_IMPORT_ERROR`, `NOT_RUNNING`, `SESSION_ACTIVE`

---

*Документация составлена по исходному коду awg‑manager (файлы server.go, api/*.go, internal/...). Актуальна для версии ≥2.8.0.*

## Что дальше?

- [Быстрый старт](../quickstart/) — создайте первый туннель и протестируйте через API
- [Руководство](../guide/) — детальные инструкции по всем функциям
- [Решение проблем](../troubleshooting/) — диагностика ошибок и восстановление
