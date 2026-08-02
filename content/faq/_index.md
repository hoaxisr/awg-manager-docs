---
title: Частые вопросы
weight: 4
---

Короткие ответы на частые вопросы. Для инструкций по функциям — [Руководство](../guide/). Для решения проблем — [Решение проблем](../troubleshooting/).


## Полезные инструменты для генерации параметров:

- [AmneziaWG Architect](https://vadim-khristenko.github.io/AmneziaWG-Architect/) — конструктор обфускации
- [Special Junk Packet List](https://voidwaifu.github.io/Special-Junk-Packet-List/) — коллекция junk-настроек для обхода разных типов DPI
- [Amnezia Signature Generator](https://spatiumstas.github.io/junker/) — генератор сигнатур
- [PayloadGen](https://sketchystan1.github.io/payloadGen/) — генератор payload'ов
- [Mini QUIC Generator](https://sageptr.github.io/mini_quic_generator/) — QUIC-маскировка
- [AmneziaWG Config Analyzer](https://pumbax.github.io/awg-analyzer/) — разбор готового конфига в браузере (тот же анализ встроен в awg-manager, см. [вкладку «Анализ конфига»](../guide/tunnels/#вкладка-анализ-конфига))

### Отличие AWG 1.0 / 1.5 / 2.0 / 3.0

- **AWG 1.0** — базовая обфускация: junk-пакеты + padding + заголовки (`Jc`, `Jmin`, `Jmax`, `S1`–`S4`, `H1`–`H4`)
- **AWG 1.5** — добавляет мимикрию под QUIC/DTLS/STUN/DNS через signature-пакеты (`I1`–`I5`)
- **AWG 2.0** — рандомизирует заголовки (`H1`–`H4` задаются диапазонами, генерируются на каждом хендшейке)
- **AWG 3.0** — шифрует заголовок WireGuard целиком (`HeaderProtectionKey`), добавляет паддинг полезной нагрузки и делает диапазонами базовые тайминги протокола, чтобы соединение не выдавало себя ритмом. Настраивается в awg-manager — см. [AmneziaWG 3.0](../guide/tunnels/#amneziawg-30)

### Как пустить **весь** трафик самого роутера через туннель?

Через `ip rule` в хуке `netfilter.d` — трафик роутера помечается как `iif lo`. Готовый скрипт и разбор: [Трафик самого роутера через туннель](../guide/ip-routing/#трафик-самого-роутера-через-туннель).

## Мониторинг и диагностика

### Нужен ли компонент ping-check в прошивке?

Только для **NativeWG**-туннелей — они используют NDMS-мониторинг, которому нужен этот компонент. Для **Kernel**-туннелей awg-manager использует собственный механизм, компонент не нужен.

### Как посмотреть логи awg-manager?

Раздел **Инструменты** → вкладка **Журнал**. Кнопка **Копировать** — выгружает содержимое в буфер обмена.

Логи хранятся в **памяти**  — отдельного файла на диске нет. После перезапуска сервиса предыдущие логи теряются.

### Есть ли API?

Да, awg-manager предоставляет HTTP REST API на том же порту, что веб-интерфейс. (см. [API awg-manager](../api/))

## Полезные внешние ресурсы

### Готовые списки доменов и IP

- [v2fly/domain-list-community](https://github.com/v2fly/domain-list-community) — большая база доменов для V2Ray/Xray, удобна для пресетов
- [RockBlack-VPN/ip-address](https://github.com/RockBlack-VPN/ip-address/tree/main) — CIDR-наборы для Keenetic
- [123jjck/cdn-ip-ranges](https://github.com/123jjck/cdn-ip-ranges) — IP-диапазоны Cloudflare / AWS / GCP и других CDN

### Альтернативные клиенты

- [wgtunnel](https://github.com/wgtunnel) — альтернативный WireGuard + AmneziaWG клиент для Android

### Свой сервер AmneziaWG

- [AwgToolza](https://t.me/awgToolza) — разворачивает AmneziaWG 2.0 на VPS одной командой: мимикрия под несколько протоколов, локальная генерация `I1`, бэкап
- [docker-amneziawg](https://github.com/AYastrebov/docker-amneziawg) — образ с поддержкой AWG 3.0
- [Официальная инструкция Amnezia для KeeneticOS](https://docs.amnezia.org/ru/documentation/instructions/keenetic-os-awg/)

### Диагностика / сетевые инструменты

- [AntiScan для Keenetic](https://forum.keenetic.ru/topic/21009-antiscan-выявление-и-блокировка-подозрительных-ip/) — защита от сканов/ботов
- [Punycode-конвертер](https://www.reg.ru/web-tools/punycode) — преобразование кириллических доменов (`.рф`, `.дети`) в ASCII-формат
- [keenetic-info](https://github.com/pumbaX/keenetic-info) — модель, версия прошивки, процессор и память роутера одной командой
- [KeenKit](https://github.com/spatiumstas/KeenKit) — бэкап и обслуживание Entware (см. [Бэкап Entware](../troubleshooting/#бэкап-entware))

## Обслуживание роутера

### Забыт пароль администратора Keenetic

Он же используется для авторизации в awg-manager и во встроенном терминале. Если остался доступ по SSH:

```bash
ndmc -c user admin password plain НОВЫЙ_ПАРОЛЬ
ndmc -c system configuration save
```

Слишком простые пароли Keenetic отклоняет.

### Кончилось место в `/opt`

Исполняемые файлы Entware сжимаются UPX:

```bash
opkg install upx
find /opt/bin /opt/sbin /opt/usr/bin /opt/libexec -type f -executable -exec upx --lzma --best {} +
```

Сжатый бинарь распаковывается в память при каждом запуске — старт чуть медленнее, расход RAM чуть выше. После обновления пакета файл заменяется несжатым, и прогон придётся повторить. Перед массовым сжатием сделайте [бэкап Entware](../troubleshooting/#бэкап-entware).

## Обратная связь

### Нашёл баг — куда писать?

- [GitHub Issues](https://github.com/hoaxisr/awg-manager/issues) — основной трекер
- При открытии issue приложите: версию awg-manager, модель роутера, версию Keenetic OS, последние 100 строк логов (см. [Troubleshooting — сбор диагностической информации](../troubleshooting/#как-собрать-диагностическую-информацию-для-issue))

### Хочу предложить фичу

Туда же — GitHub Issues с меткой `enhancement`. Опишите сценарий использования и ожидаемое поведение.

## Что дальше?

- [Быстрый старт](../quickstart/) — создать первый туннель за 5 минут
- [Руководство](../guide/) — подробные разделы по каждой функции
- [Решение проблем](../troubleshooting/) — если что-то пошло не так
- [API](../api/) — автоматизация через API
