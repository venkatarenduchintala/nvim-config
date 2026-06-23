FROM debian:12-slim AS base

ARG APP_VERSION=1.0.0

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

FROM base AS builder

COPY . .

RUN chmod +x ./entrypoint.sh

FROM base AS runtime

COPY --from=builder /app/entrypoint.sh /usr/local/bin/entrypoint.sh

ENV APP_VERSION=${APP_VERSION}

EXPOSE 8080

USER nobody

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
