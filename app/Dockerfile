FROM python:3.5
WORKDIR /usr/src/app
COPY ./python-postgres-user-registration .
RUN pip install --no-cache-dir -r requirements.txt
CMD [ "python", "./app.py" ]