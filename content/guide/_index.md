---
title: Руководство
weight: 3
cascade:
  type: docs
---

Подробные разделы по каждой функции awg-manager.

## Туннели

{{< cards >}}
  {{< card link="tunnels" title="Управление туннелями" icon="switch-horizontal" subtitle="Создание, редактирование, параметры обфускации, маршрут по умолчанию." >}}
  {{< card link="monitoring" title="Мониторинг" icon="chart-bar" subtitle="Карточки-watchdog и автоматический перезапуск при потере соединения." >}}
  {{< card link="servers" title="Серверы" icon="server" subtitle="Встроенный и собственные WireGuard-серверы роутера, клиенты, NAT-режимы." >}}
{{< /cards >}}

## Маршрутизация

{{< cards >}}
  {{< card link="routing" title="Как выбрать маршрутизацию" icon="map" subtitle="Сравнение шести механизмов и типовые сценарии выбора." >}}
  {{< card link="dns-routing" title="DNS-маршрутизация (NDMS)" icon="globe-alt" subtitle="Правила по FQDN, пресеты популярных сервисов." >}}
  {{< card link="ip-routing" title="Маршрутизация по IP" icon="hashtag" subtitle="Правила по IP и CIDR, Kill Switch, импорт из .bat." >}}
  {{< card link="hr-neo" title="HydraRoute Neo" icon="sparkles" subtitle="Альтернативный движок: geosite/geoip-теги, готовые списки." >}}
  {{< card link="clientvpn" title="VPN для устройств" icon="device-mobile" subtitle="Привязка конкретных устройств локальной сети к туннелю." >}}
  {{< card link="policy" title="Политики доступа" icon="user-group" subtitle="Политики на уровне интерфейсов с fallback (OS 5.x)." >}}
{{< /cards >}}

## Sing-box

{{< cards >}}
  {{< card link="singbox" title="Обзор раздела" icon="cube" subtitle="Что такое sing-box и какие протоколы поддерживает." >}}
  {{< card link="singbox/tunnels" title="Sing-box туннели" icon="link" subtitle="Импорт VLESS / Hysteria2 / NaiveProxy и других по share-ссылкам." >}}
  {{< card link="singbox/subscriptions" title="Sing-box подписки" icon="collection" subtitle="Группы серверов из подписок провайдеров." >}}
  {{< card link="singbox/router-quickstart" title="Router — пример настройки" icon="play" subtitle="Пошаговая инструкция на примере RuTube." >}}
  {{< card link="singbox/router" title="Sing-box Router" icon="cog" subtitle="Справочник по движку: режимы TProxy и Fake-IP, правила, DNS, прокси." >}}
{{< /cards >}}

## Прочее

{{< cards >}}
  {{< card link="diagnostics" title="Инструменты" icon="beaker" subtitle="Журнал, мониторинг, соединения, автоматические проверки, окружение." >}}
  {{< card link="settings" title="Настройки" icon="adjustments" subtitle="Уровни использования, обновление, журналы, интеграции." >}}
  {{< card link="terminal" title="Терминал" icon="terminal" subtitle="Командная строка роутера в браузере (ttyd)." >}}
{{< /cards >}}
