---
title: awg-manager
toc: false
---

{{< hextra/hero-badge >}}
<div class="hx-w-2 hx-h-2 hx-rounded-full hx-bg-primary-400"></div>
Свежий релиз — [v2.8.2]
{{< /hextra/hero-badge >}}

<div class="hx-mt-6 hx-mb-6">
{{< hextra/hero-headline >}}
Веб-интерфейс для AmneziaWG на Keenetic
{{< /hextra/hero-headline >}}
</div>

<div class="hx-mb-12">
{{< hextra/hero-subtitle >}}
Настройка VPN через браузер вместо редактирования конфигов в SSH. Выборочная маршрутизация по доменам, IP и устройствам. Встроенная диагностика и автоперезапуск при потере связи.
{{< /hextra/hero-subtitle >}}
</div>

<div class="hx-mb-6">
{{< hextra/hero-button text="Установка" link="install" >}}
&nbsp;&nbsp;
{{< hextra/hero-button text="Быстрый старт" link="quickstart" style="background: transparent; border: 1px solid currentColor;" >}}
</div>

![Главный экран awg-manager](/img/landing/hero.png)

<div class="hx-mt-16"></div>

## Возможности

{{< cards >}}
  {{< card link="guide/tunnels/" title="Управление туннелями" subtitle="Импорт .conf, vpn:// ссылок AmneziaVPN, расширенные AWG-параметры. Два режима backend: NativeWG (интеграция с Keenetic OS) и Kernel (через Entware)." >}}
  {{< card link="guide/dns-routing/" title="DNS-маршрутизация" subtitle="Правила по именам доменов через NDMS. Каталог готовых пресетов для популярных сервисов — Vkontakte, Rutube, Ozon, Kinopoisk и другие." >}}
  {{< card link="guide/ip-routing/" title="Маршруты по IP" subtitle="CIDR-правила без зависимости от DNS. Работает на OS 4.x и 5.x. Импорт из Windows .bat-скриптов. Kill Switch при падении туннеля." >}}
  {{< card link="guide/hr-neo/" title="HydraRoute Neo" subtitle="Альтернативный движок маршрутизации. Geosite/geoip-теги, готовые списки по странам и сервисам, гибкая привязка к политикам Keenetic." >}}
  {{< card link="guide/monitoring/" title="Мониторинг туннелей" subtitle="Автоматическая проверка связности (ICMP, TCP, TLS, HTTP) и авто-перезапуск при падении. Подробный журнал проверок." >}}
  {{< card link="guide/clientvpn/" title="VPN для устройств" subtitle="Привязка конкретного устройства локальной сети к туннелю через source-based routing. Kill Switch или обход VPN при падении." >}}
{{< /cards >}}

<div class="hx-mt-16"></div>

## Начать за 2 минуты

```bash
# На роутере через SSH:
opkg update
opkg install wget-ssl ca-bundle curl
wget -qO- https://raw.githubusercontent.com/hoaxisr/awg-manager/main/scripts/install.sh | sh
```

Установщик определит архитектуру, добавит репозиторий, установит пакет и выведет URL веб-интерфейса.

[Подробная инструкция →](install)

<div class="hx-mt-16"></div>

## Поддерживаемые устройства

Поддерживаются роутеры Keenetic с возможностью установки Entware из актуальной линейки.

<div class="hx-mt-16"></div>

## Проект

- **Исходный код:** [github.com/hoaxisr/awg-manager](https://github.com/hoaxisr/awg-manager)
- **Репозиторий пакетов opkg:** [repo.hoaxisr.ru](http://repo.hoaxisr.ru)
- **Changelog:** [релизы на GitHub](https://github.com/hoaxisr/awg-manager/releases)
- **Issue / фичреквесты:** [GitHub Issues](https://github.com/hoaxisr/awg-manager/issues)
- **TG Канал Общения** [Telegram](https://t.me/awgmanager)
