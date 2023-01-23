FROM python:3-alpine
ARG version
LABEL maintainer="Massimo Santini santini@di.unimi.it"
RUN apk add --no-cache --update python3 py3-pip; \
    pip3 install flask flask-mail gunicorn
COPY ./dist/scythe_mail_merge-$version-py3-none-any.whl /tmp
RUN pip install /tmp/scythe_mail_merge-$version-py3-none-any.whl && rm -f /tmp/scythe_mail_merge-$version-py3-none-any.whl
EXPOSE 8000
RUN mkdir -p /app/instance
RUN chmod -R a+rX /app
WORKDIR /app
CMD ["gunicorn", "--bind=0.0.0.0:8080", "--workers", "4", "smm:app"]
