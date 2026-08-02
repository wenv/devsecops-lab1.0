# CORRECCIÓN CONTENEDOR: Imagen base moderna y actualizada
FROM python:3.11-alpine

RUN apk update && apk upgrade --no-cache

WORKDIR /app

# Crear usuario no privilegiado
RUN useradd -D appuser

COPY app/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app/ .
RUN pip install --no-cache-dir -r requirements.txt

# Cambiar a usuario no-root
USER appuser

EXPOSE 8080

# Directiva requerida por Checkov para contenedores 
HEALTHCHECK --interval=30s --timeout=3s CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8080/buscar')" || exit 1

CMD ["python", "app.py"]
