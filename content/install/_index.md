---
title: Установка
weight: 1
---

awg-manager устанавливается на роутер Keenetic через пакетный менеджер `opkg`. Последовательность: компонент Wireguard → Entware (если ещё нет) → SSH → awg-manager.

## Требования

- Роутер **Keenetic** с USB-портом (или встроенной памятью для хранения Entware)
- Прошивка **Keenetic OS 4.x** или **5.x**
- Одна из поддерживаемых архитектур: `mipsel-3.4`, `mips-3.4`, `aarch64-3.10`
- Установлен компонент **Wireguard** в Keenetic OS — веб-интерфейс роутера → **Управление** → **Настройки системы** → **Изменить набор компонентов** → включить **Wireguard VPN**

{{< callout type="info" >}}
Проверить архитектуру — подключитесь к роутеру по SSH и выполните `opkg print-architecture | grep _kn`.
{{< /callout >}}

## Шаг 1 — установить Entware

Если Entware уже установлен — пропускайте.

**Определите архитектуру процессора роутера:**

- **Mipsel** — чипы MT7628 / MT7621
- **Aarch64** — чипы MT7622 / MT7981 / MT7988 (ARM)

**Способ A — через браузер (Keenetic OS 4.2+)**

Откройте `http://192.168.1.1/a` в браузере — встроенный мастер Entware проведёт по шагам.

**Способ B — одной командой через CLI**

Зайдите на `http://192.168.1.1/a` (CLI) и выполните одну из команд:

```bash
# Mipsel (MT7628 / MT7621)
opkg disk storage:/ https://bin.entware.net/mipselsf-k3.4/installer/mipsel-installer.tar.gz

# Aarch64 (MT7622 / MT7981 / MT7988)
opkg disk storage:/ https://bin.entware.net/aarch64-k3.10/installer/aarch64-installer.tar.gz
```

Установка занимает около минуты.

## Шаг 2 — подключиться по SSH

Данные по умолчанию:

- **IP**: `192.168.1.1`
- **Порт**: `222` (если установлен компонент Keenetic SSH) или `22` (если Entware поднял свой OpenSSH)
- **Логин**: `root`
- **Пароль**: `keenetic`

{{< callout type="warning" >}}
**Немедленно смените пароль после первого входа:**

```bash
passwd
```

Стандартный пароль `keenetic` известен всем — оставлять его на доступной из интернета машине опасно.
{{< /callout >}}

Для Windows — [PuTTY](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html) или WSL. Для Linux/macOS — `ssh root@192.168.1.1 -p 222`.

## Шаг 3 — установить awg-manager

### Быстрая установка (рекомендуется)

```bash
opkg update
opkg install wget-ssl ca-bundle curl
wget -qO- https://raw.githubusercontent.com/hoaxisr/awg-manager/main/scripts/install.sh | sh
```

Установщик определит архитектуру, добавит репозиторий, скачает и установит пакет, запустит сервис. В последней строке выведется URL веб-интерфейса.

Повторный запуск той же команды — обновление до последней версии.

### Ручная установка

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

После установки сервис стартует автоматически. Порт **2222** по умолчанию — если занят, awg-manager сам выберет свободный.

При установке через `install.sh` итоговая ссылка выводится в последней строке:

```
[+] ========================================
[+]   AWG Manager: http://192.168.1.1:2222
[+] ========================================
```

Откройте этот URL в браузере. Если ссылку пропустили — актуальный порт виден в `/opt/etc/awg-manager/settings.json` (поле `port`).

По умолчанию UI открыт без авторизации. Если хотите защитить доступ — включите авторизацию в разделе **Настройки**: awg-manager начнёт требовать учётные данные администратора Keenetic (те же, что и для входа в веб-интерфейс роутера).

![awg-manager после первого входа](/img/install/ui-first-login.png)

## Обновление

Повторный запуск установщика обновит до последней версии:

```bash
wget -qO- https://raw.githubusercontent.com/hoaxisr/awg-manager/main/scripts/install.sh | sh
```

Или вручную:

```bash
opkg update
opkg upgrade awg-manager
```

## Установка конкретной версии (downgrade)

Если нужна более ранняя стабильная версия (например, после релиза с регрессией) — напрямую из репозитория:

```bash
# Для aarch64:
opkg install --force-downgrade http://repo.hoaxisr.ru/aarch64-k3.10/awg-manager_2.3.11_aarch64-3.10-kn.ipk

# Для mipsel:
opkg install --force-downgrade http://repo.hoaxisr.ru/mipsel-k3.4/awg-manager_2.3.11_mipsel-3.4-kn.ipk

# Для mips:
opkg install --force-downgrade http://repo.hoaxisr.ru/mips-k3.4/awg-manager_2.3.11_mips-3.4-kn.ipk
```

Замените `2.3.11` на нужную версию. Полный список релизов — на [GitHub](https://github.com/hoaxisr/awg-manager/releases).

{{< callout type="warning" >}}
При переходе между версиями может потребоваться **пересоздать туннели** (загрузить конфиги заново). По старым версиям поддержка не осуществляется.
{{< /callout >}}

## Полное удаление

```bash
opkg remove awgm-alpha awg-manager && \
rm -f /opt/etc/opkg/awg_manager.conf && \
rm -rf /opt/etc/awg-manager /opt/var/lib/awg-manager /opt/var/log/awg-manager && \
opkg update
```

Удалит пакет (основной и alpha), файл репозитория, все настройки, данные и логи. Если хотите сохранить настройки для переустановки — уберите `rm -rf /opt/etc/awg-manager` из команды.

## Проблемы при установке

- **"Не удалось определить архитектуру"** — значит Entware не найден. Вернитесь к **Шагу 1**
- **Entware не устанавливается / накопитель "занят"** — возможно нужно [отформатировать накопитель](../troubleshooting/#форматирование-накопителя-entware)
- **"Connection refused" при заходе в UI** — сервис не успел стартовать. Подождите 10–20 секунд, обновите страницу
- **Не помню, на каком порту сервис** — подключитесь по SSH и выполните `cat /opt/etc/awg-manager/settings.json`, поле `port`

## Что дальше?

- [Быстрый старт](../quickstart/) — создать первый туннель за 5 минут
- [Руководство](../guide/) — подробные разделы по каждой функции
- [Решение проблем](../troubleshooting/) — если что-то пошло не так
