FROM python:3.9-slim-buster

WORKDIR /

ADD . /

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8080

ENV PORT 8080

CMD ["python", "main.py"]
