---
title: Частые вопросы
weight: 4
---

Короткие ответы на частые вопросы. Для инструкций по функциям — [Руководство](../guide/). Для решения проблем — [Решение проблем](../troubleshooting/).


## Полезные инструменты для генерации параметров:

- [AmneziaWG Architect](https://vadim-khristenko.github.io/AmneziaWG-Architect/) — конструктор обфускации
- [Special Junk Packet List](https://voidwaifu.github.io/Special-Junk-Packet-List/) — коллекция junk-настроек для обхода разных типов DPI
- [PayloadGen](https://sketchystan1.github.io/payloadGen/) — генератор payload'ов
- [Mini QUIC Generator](https://sageptr.github.io/mini_quic_generator/) — QUIC-маскировка

### Отличие AWG 1.0 / 1.5 / 2.0 / 3.0

- **AWG 1.0** — базовая обфускация: junk-пакеты + padding + заголовки (`Jc`, `Jmin`, `Jmax`, `S1`–`S4`, `H1`–`H4`)
- **AWG 1.5** — добавляет мимикрию под QUIC/DTLS/STUN/DNS через signature-пакеты (`I1`–`I5`)
- **AWG 2.0** — рандомизирует заголовки (`H1`–`H4` задаются диапазонами, генерируются на каждом хендшейке)
- **AWG 3.0** — добавляет новые возможности шифрования заголовков пакетов, рандомизирует базовые тайминги Wireguard (например, `HandshakeTimeout` и `KeepAliveInterval`)

### Как пустить **весь** трафик самого роутера через туннель?

Воспользуйтесь iptables и ip rule в Entware. Более подробно — см. [Скрипт направления к Github](https://t.me/awgmanager/4211/60892)

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

### Диагностика / сетевые инструменты

- [AntiScan для Keenetic](https://forum.keenetic.ru/topic/21009-antiscan-выявление-и-блокировка-подозрительных-ip/) — защита от сканов/ботов
- [Punycode-конвертер](https://www.reg.ru/web-tools/punycode) — преобразование кириллических доменов (`.рф`, `.дети`) в ASCII-формат

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
