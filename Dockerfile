# ---- Этап сборки зависимостей ----
FROM python:3.12-slim AS builder

# Устанавливаем Poetry последней версии (поддержка PEP 621)
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir poetry==2.1.2

# Настраиваем Poetry (создаёт виртуальное окружение внутри проекта)
ENV POETRY_VIRTUALENVS_IN_PROJECT=true \
    POETRY_NO_INTERACTION=1

WORKDIR /app

# Копируем файлы с зависимостями
COPY pyproject.toml poetry.lock ./

# Устанавливаем все зависимости (без создания виртуального окружения отдельно — Poetry сам создаст .venv)
RUN poetry install --no-root

# ---- Финальный образ приложения ----
FROM python:3.12-slim

WORKDIR /app

# Копируем виртуальное окружение из builder
COPY --from=builder /app/.venv /app/.venv

# Копируем весь код проекта
COPY . .

# Переменные окружения
ENV PATH="/app/.venv/bin:$PATH" \
    PYTHONUNBUFFERED=1 \
    DJANGO_SETTINGS_MODULE=config.settings.production

# Открываем порт, на котором работает Gunicorn
EXPOSE 8000

# Запуск Gunicorn
CMD ["gunicorn", "config.wsgi:application", "--bind", "0.0.0.0:8000", "--workers", "4"]