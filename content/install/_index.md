---
title: Установка
weight: 1
---

awg-manager устанавливается на роутер Keenetic через пакетный менеджер `opkg`. Есть два способа — быстрый (рекомендуемый) и ручной.

## Требования

- Роутер **Keenetic** с поддержкой Entware (большинство моделей с USB-портом)
- **Entware** уже установлен и работает — см. [официальный гайд Keenetic](https://help.keenetic.com/hc/ru/articles/360021214160)
- Установлен компонент **Wireguard** в Keenetic OS — веб-интерфейс роутера → **Управление** → **Настройки системы** → **Изменить набор компонентов** → включить **Wireguard VPN**
- Прошивка **Keenetic OS 4.x** или **5.x**
- Одна из поддерживаемых архитектур: `mipsel-3.4`, `mips-3.4`, `aarch64-3.10`

{{< callout type="info" >}}
Проверить архитектуру — подключитесь к роутеру по SSH и выполните `opkg print-architecture | grep _kn`.
{{< /callout >}}

## Быстрая установка

Одна команда — определит архитектуру, добавит репозиторий, установит пакет и запустит сервис:

```bash
curl -sL https://raw.githubusercontent.com/hoaxisr/awg-manager/main/scripts/install.sh | sh
```

Если нет `curl`:

```bash
wget -qO- https://raw.githubusercontent.com/hoaxisr/awg-manager/main/scripts/install.sh | sh
```

Повторный запуск той же команды — обновление до последней версии.

## Ручная установка

Если предпочитаете не запускать внешний скрипт:

```bash
# 1. Определить архитектуру репозитория (aarch64-k3.10 / mipsel-k3.4 / mips-k3.4)
ARCH=$(opkg print-architecture | grep '_kn' | awk '{print $2}' | sed 's/_kn.*//' | sed 's/-\([0-9]\)/-k\1/')

# 2. Добавить репозиторий
echo "src/gz hoaxisr http://repo.hoaxisr.ru/${ARCH}" > /opt/etc/opkg/awg_manager.conf

# 3. Установить
opkg update
opkg install awg-manager
```

## Первый вход

После установки сервис стартует автоматически. Порт **2222** по умолчанию — если он занят, awg-manager сам выберет свободный.

При установке через `install.sh` итоговая ссылка выводится в последней строке:

```
[+] ========================================
[+]   AWG Manager: http://192.168.1.1:2222
[+] ========================================
```

Откройте этот URL в браузере. Если ссылку пропустили — актуальный порт всегда виден в `/opt/etc/awg-manager/settings.json` (поле `port`).

По умолчанию UI открыт без авторизации. Если хотите защитить доступ — включите авторизацию в разделе **Настройки**: awg-manager начнёт требовать учётные данные администратора Keenetic (те же, что и для входа в веб-интерфейс роутера).

![awg-manager после первого входа](/img/install/ui-first-login.png)

## Обновление

Повторный запуск установщика обновит до последней версии:

```bash
curl -sL https://raw.githubusercontent.com/hoaxisr/awg-manager/main/scripts/install.sh | sh
```

Или вручную:

```bash
opkg update
opkg upgrade awg-manager
```

## Удаление

```bash
opkg remove awg-manager
```

Остановит сервис и удалит пакет. Данные в `/opt/etc/awg-manager/` останутся — удалите их отдельно, если нужна полная очистка.

## Проблемы при установке

- **"Не удалось определить архитектуру"** — значит Entware не найден. Установите его по [официальному гайду Keenetic](https://help.keenetic.com/hc/ru/articles/360021214160)
- **"Connection refused" при заходе в UI** — сервис не успел стартовать. Подождите 10–20 секунд, обновите страницу
- **Не помню, на каком порту сервис** — подключитесь по SSH и выполните `cat /opt/etc/awg-manager/settings.json`, поле `port`

## Что дальше?

- [Быстрый старт](../quickstart/) — создать первый туннель за 5 минут
- [Руководство](../guide/) — подробные разделы по каждой функции
- [Решение проблем](../troubleshooting/) — если что-то пошло не так
