---
title: awg-manager
toc: false
---

<div class="hx-mt-6"></div>

{{< hextra/hero-badge link="https://github.com/hoaxisr/awg-manager/releases/latest" >}}
<div class="hx-w-2 hx-h-2 hx-rounded-full hx-bg-primary-400"></div>
Свежий релиз — v2.16.5 →
{{< /hextra/hero-badge >}}

<div class="hx-mt-6 hx-mb-6">
{{< hextra/hero-headline >}}
Туннели и прокси. Просто.
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
{{< hextra/hero-button text="Быстрый старт" link="quickstart" style="background: transparent; border: 1px solid currentColor; color: inherit;" >}}
</div>

![Главный экран awg-manager](/img/landing/hero.png)

<div class="hx-mt-16"></div>

## Возможности

{{< cards >}}
  {{< card link="guide/tunnels/" title="Управление туннелями" icon="switch-horizontal" subtitle="Импорт .conf, vpn:// ссылок AmneziaVPN, AWG 1.0/1.5/2.0/3.0. Keenetic OS 4.x и 5.x." >}}
  {{< card link="guide/singbox/" title="Sing-box" icon="cube" subtitle="VLESS, Hysteria2, NaiveProxy, Mieru: прокси, подписки и маршрутизация." >}}
  {{< card link="guide/routing/" title="Выбор маршрутизации" icon="map" subtitle="Шесть механизмов — таблица и сценарии, которые помогут выбрать подходящий." >}}
  {{< card link="guide/dns-routing/" title="DNS-маршрутизация" icon="globe-alt" subtitle="Правила по именам доменов через NDMS. Каталог готовых пресетов сервисов." >}}
  {{< card link="guide/ip-routing/" title="Маршруты по IP" icon="hashtag" subtitle="CIDR-правила без зависимости от DNS. Импорт из .bat. Kill Switch." >}}
  {{< card link="guide/hr-neo/" title="HydraRoute Neo" icon="sparkles" subtitle="Альтернативный движок: geosite/geoip-теги, готовые списки по странам и сервисам." >}}
  {{< card link="guide/freeturn/" title="FreeTurn" icon="lightning-bolt" subtitle="TURN-туннель для живущих далеко: возможность позвонить из Голладнии в село Светлая дача" >}}
  {{< card link="guide/monitoring/" title="Мониторинг туннелей" icon="chart-bar" subtitle="Карточки-watchdog с метриками проверок и авто-перезапуск при потере связности." >}}
  {{< card link="guide/clientvpn/" title="VPN для устройств" icon="device-mobile" subtitle="Привязка устройства локальной сети к туннелю через source-based routing." >}}
  {{< card link="guide/settings/#уровни-использования" title="Уровни использования" icon="adjustments" subtitle="Базовый, Расширенный, Продвинутый — скрывайте то, чем не пользуетесь." >}}
{{< /cards >}}

<div class="hx-mt-16"></div>

## Начать за 2 минуты

```bash
# На роутере через SSH:
opkg update
opkg upgrade
wget -qO- http://repo.hoaxisr.ru/install.sh | sh
```

Установщик определит архитектуру, добавит репозиторий, установит пакет и выведет URL веб-интерфейса.

[Подробная инструкция →](install)

<div class="hx-mt-16"></div>

## Справка

{{< cards >}}
  {{< card link="quickstart/" title="Быстрый старт" icon="play" subtitle="Первый туннель за 5 минут: импорт конфига, запуск, проверка." >}}
  {{< card link="faq/" title="Частые вопросы" icon="question-mark-circle" subtitle="Короткие ответы: обфускация, лимиты туннелей, порты, ключи." >}}
  {{< card link="troubleshooting/" title="Решение проблем" icon="support" subtitle="Типичные сбои и их разбор: туннель не поднимается, правила не срабатывают." >}}
  {{< card link="api/" title="API" icon="code" subtitle="HTTP REST API для автоматизации — на том же порту, что веб-интерфейс." >}}
{{< /cards >}}

<div class="hx-mt-16"></div>

## Поддерживаемые устройства

Поддерживаются роутеры Keenetic с возможностью установки Entware из актуальной линейки, включая "кинетикозаменители".

<div class="hx-mt-16"></div>

## Проект

- **Исходный код:** [github.com/hoaxisr/awg-manager](https://github.com/hoaxisr/awg-manager)
- **Репозиторий пакетов opkg:** [repo.hoaxisr.ru](http://repo.hoaxisr.ru)
- **Changelog:** [релизы на GitHub](https://github.com/hoaxisr/awg-manager/releases)
- **Баги / Запросы новых функций:** [GitHub Issues](https://github.com/hoaxisr/awg-manager/issues)
- **TG Канал Общения** [Telegram](https://t.me/awgmanager)
