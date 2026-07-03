---
title: Sing-box
weight: 9
---

**Sing-box** — отдельный движок туннелей в awg-manager для протоколов, которые не поддерживает AmneziaWG: **VLESS/Reality**, **Trojan**, **Shadowsocks**, **Hysteria2**, **NaiveProxy**, **Mieru**. Работает параллельно с AmneziaWG-туннелями, устанавливается и обновляется из UI. Разделы Sing-box видны начиная с уровня использования **Расширенный** (см. [Настройки](../settings/#уровни-использования)).

Sing-box не заменяет AmneziaWG, а добавляет поддержку других протоколов, расширяя возможности подключений.

{{< callout type="warning" >}}
Установка sing-box требует значительного места и **обязательно** Entware на внешнем USB-накопителе — на встроенной памяти роутера её не хватит. Подготовка флешки и установка Entware описаны в разделе [Установка](../../install/#шаг-1--установить-entware).
{{< /callout >}}

{{< cards >}}
  {{< card link="tunnels/" title="Sing-box туннели" subtitle="Импорт и управление туннелями VLESS/Reality, Trojan, Shadowsocks, Hysteria2, NaiveProxy и Mieru." >}}
  {{< card link="subscriptions/" title="Sing-box подписки" subtitle="Подписка на список серверов — мастер скачивает каталог и создаёт selector-туннель." >}}
  {{< card link="router/" title="Sing-box Router" subtitle="Маршрутизация устройств через sing-box: режимы TProxy (netfilter) и Fake-IP (TUN); доступна только на уровне Продвинутый." >}}
{{< /cards >}}
