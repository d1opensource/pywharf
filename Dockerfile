FROM debian:buster-slim AS build
RUN apt-get update && \
    apt-get install --no-install-suggests --no-install-recommends --yes python3-venv gcc libpython3-dev curl git && \
    python3 -m venv /venv && \
    /venv/bin/pip install --upgrade pip wheel && \
    /venv/bin/pip install -U poetry

ADD . /dist
WORKDIR /dist

RUN . /venv/bin/activate && poetry config virtualenvs.create false && poetry build && pip install dist/pywharf-*.whl

FROM gcr.io/distroless/python3-debian10
COPY --from=build /venv /venv
ENV PATH /venv/bin:$PATH
ENTRYPOINT ["pywharf"]
