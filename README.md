# awg-manager-docs

Исходники сайта документации https://awgm.hoaxisr.ru для [awg-manager](https://github.com/hoaxisr/awg-manager).

Сайт собран на [Hugo](https://gohugo.io) (extended) с темой [Hextra](https://imfing.github.io/hextra/).

## Требования

- Hugo **extended**, версия **не ниже 0.134** (минимум темы Hextra; пакет из apt Ubuntu 24.04 — 0.123 — не подходит). На Arch: `sudo pacman -S hugo`. На Debian/Ubuntu: скачать `_extended_` deb с https://github.com/gohugoio/hugo/releases.
- Git (для submodule темы).

## Деплой

Сайт автоматически собирается и публикуется на GitHub Pages при пуше в `main` (workflow `.github/workflows/hugo.yml`). Превью: https://hoaxisr.github.io/awg-manager-docs/

## Локальная разработка

```bash
git clone --recurse-submodules https://github.com/hoaxisr/awg-manager-docs.git
cd awg-manager-docs
make dev    # http://localhost:1313, авто-перезагрузка
```

Если клонировали без `--recurse-submodules`:

```bash
git submodule update --init --recursive
```

## Windows подготовка

```bash
wsl
sudo apt update && sudo apt install snapd
sudo snap install hugo
exit
wsl
hugo -v
```

## Сборка

```bash
make build   # результат в public/
```

## Структура

- `content/` — страницы в Markdown
- `static/img/` — скриншоты и ассеты
- `hugo.toml` — конфиг сайта
- `themes/hextra/` — тема (git submodule)
- `layouts/` — локальные override'ы шаблонов темы

## Вклад

PR с правками и улучшениями приветствуются. Для обсуждения нового контента открывайте issue.
