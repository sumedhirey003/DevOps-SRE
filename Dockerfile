ARG PYTHON_VERSION=3.12
FROM python:${PYTHON_VERSION}-alpine

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 



RUN set -eux; \
    python -m pip uninstall -y setuptools wheel pip; \
    rm -rf /usr/local/lib/python3.13/ensurepip \
           /usr/local/lib/python3.13/site-packages/pip \
           /usr/local/lib/python3.13/site-packages/pip-*.dist-info; \
    addgroup -S -g 10001 app; \
    adduser -S -u 10001 -G app app

WORKDIR /app

COPY --chown=10001:10001 app/ ./

USER 10001:10001

EXPOSE 8080

HEALTHCHECK --interval=10s --timeout=3s --start-period=5s --retries=3 \
    CMD python -c "from urllib.request import urlopen; urlopen('http://127.0.0.1:8080/healthcheck', timeout=2)"

CMD ["python", "app.py"]