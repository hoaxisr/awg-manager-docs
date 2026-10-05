---
title: awg-manager
toc: false
---

<div style="display:flex;flex-direction:column;align-items:center;text-align:center;">

<div class="hx-mt-6"></div>

{{< hextra/hero-badge link="https://github.com/hoaxisr/awg-manager/releases/latest" >}}
<div class="hx-w-2 hx-h-2 hx-rounded-full hx-bg-primary-400"></div>
Свежий релиз →
{{< /hextra/hero-badge >}}

<div class="hx-mt-6 hx-mb-6">
{{< hextra/hero-headline >}}
Туннели и прокси. Просто.
{{< /hextra/hero-headline >}}
</div>

<div class="hx-mb-12">
{{< hextra/hero-subtitle >}}
Настройка VPN через браузер вместо редактирования конфигов в SSH. Выборочная маршрутизация по доменам, IP и устройствам. Собственный WireGuard-сервер на роутере. Встроенная диагностика и автоперезапуск при потере связи.
{{< /hextra/hero-subtitle >}}
</div>

<div class="hx-mb-6">
{{< hextra/hero-button text="Установка" link="install" >}}
&nbsp;&nbsp;
{{< hextra/hero-button text="Быстрый старт" link="quickstart" style="background: transparent; border: 1px solid currentColor; color: inherit;" >}}
</div>

</div>

![Главный экран awg-manager](/img/landing/hero.png)

<div class="hx-mt-16"></div>

## Возможности

{{< cards cols="3" >}}
  {{< card link="guide/tunnels/" title="AmneziaWG и WireGuard" icon="switch-horizontal" subtitle="Импорт .conf и vpn:// ссылок, AWG 1.0–3.1, PhobosWG, ClusterM Obfuscator." >}}
  {{< card link="guide/singbox/" title="Sing-box" icon="cube" subtitle="VLESS, Hysteria2, NaiveProxy, Mieru и подписки провайдеров." >}}
  {{< card link="guide/freeturn/" title="Прокси" icon="lightning-bolt" subtitle="Туннель для живущих далеко: возможность позвонить по туннелю" >}}
  {{< card link="guide/routing/" title="Маршрутизация" icon="map" subtitle="По доменам, IP и устройствам: шесть механизмов и как выбрать нужный." >}}
  {{< card link="guide/clientvpn/" title="VPN для устройств" icon="device-mobile" subtitle="Отдельное устройство сети целиком через выбранный туннель." >}}
  {{< card link="guide/servers/" title="Серверы" icon="server" subtitle="Свой WireGuard/AmneziaWG-сервер на роутере, клиенты по QR." >}}
  {{< card link="guide/monitoring/" title="Мониторинг" icon="chart-bar" subtitle="Проверки связности и автоперезапуск упавших туннелей." >}}
  {{< card link="guide/diagnostics/" title="Инструменты" icon="beaker" subtitle="Журнал, живые соединения, проверки, анализатор конфигов." >}}
  {{< card link="guide/diagnostics/system/" title="Система" icon="chip" subtitle="Файлы, службы, пакеты, порты и процессы роутера без SSH." >}}
{{< /cards >}}

<div class="hx-mt-16"></div>

## Нужна помощь

{{< cards cols="3" >}}
  {{< card link="faq/" title="Вопросы и решения" icon="question-mark-circle" subtitle="Частые вопросы и типичные проблемы." >}}
  {{< card link="guide/diagnostics/checks/" title="Проверки" icon="clipboard-check" subtitle="Автоматическая диагностика роутера и туннелей." >}}
  {{< card link="https://t.me/awgmanager" title="Чат в Telegram" icon="telegram" subtitle="Спросить, если ничего не помогло." >}}
{{< /cards >}}

<div class="hx-mt-16"></div>

[Исходный код](https://github.com/hoaxisr/awg-manager) · [Репозиторий opkg](http://repo.hoaxisr.ru) · [Changelog](https://github.com/hoaxisr/awg-manager/releases) · [Баги и предложения](https://github.com/hoaxisr/awg-manager/issues) · Роутеры Keenetic с Entware, включая «кинетикозаменители»
