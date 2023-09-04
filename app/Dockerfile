FROM python:3.9-slim

RUN mkdir /opt/app/

COPY ./ /opt/app/

RUN pip install -r /opt/app/requirements.txt

WORKDIR /opt/app/

EXPOSE 5000

CMD ["python", "app.py"]
