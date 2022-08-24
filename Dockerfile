FROM python:3.10 AS export
RUN pip --no-cache-dir install pipenv
COPY Pipfile Pipfile.lock ./
RUN pipenv requirements > /requirements.lock \
    && pipenv requirements --dev > /requirements-dev.lock

FROM python:3.10 AS builder
COPY --from=export /requirements.lock /
RUN pip install --no-cache-dir -r /requirements.lock

FROM python:3.10 AS dev-builder
COPY --from=export /requirements-dev.lock /
RUN pip install --no-cache-dir -r /requirements-dev.lock

FROM python:3.10-slim AS base
WORKDIR /app

RUN apt-get update \
    && apt-get -y install \
      libpq5 \
      libxml2 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

CMD ["uwsgi", "--ini", "hello_django/uwsgi.ini"]
EXPOSE 8000

FROM base AS dev
COPY --from=dev-builder /usr/local/lib/python3.10/site-packages /usr/local/lib/python3.10/site-packages
COPY --from=dev-builder /usr/local/bin /usr/local/bin

COPY ./ ./

FROM base AS prod
COPY --from=builder /usr/local/lib/python3.10/site-packages /usr/local/lib/python3.10/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin

COPY ./ ./
