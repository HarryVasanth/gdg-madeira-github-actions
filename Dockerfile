FROM alpine:3.24

RUN apk add --no-cache bash

WORKDIR /app
COPY scripts/random/ ./scripts/random/

CMD ["bash", "scripts/random/dice.sh"]
