FROM jupyter/base-notebook:latest

USER root

# Install system dependencies
RUN apt-get update && apt-get install -y \
    sqlite3 \
    && rm -rf /var/lib/apt/lists/*

# Install Python packages
RUN pip install --no-cache-dir \
    mlflow==3.8.0rc0 \
    scikit-learn \
    pandas \
    numpy \
    matplotlib \
    seaborn

# Create directories
RUN mkdir -p /mlflow/artifacts /home/jovyan/work && \
    chown -R jovyan:users /mlflow /home/jovyan/work

USER jovyan

WORKDIR /home/jovyan/work

# Expose ports for Jupyter and MLflow
EXPOSE 8888 5000

# Create startup script
USER root
RUN echo '#!/bin/bash\n\
mlflow server --host 0.0.0.0 --port 5000 \\\n\
  --backend-store-uri sqlite:///mlflow/mlflow.db \\\n\
  --default-artifact-root /mlflow/artifacts \\\n\
  --serve-artifacts --gunicorn-opts "--timeout 120" &\n\
\n\
exec start-notebook.sh "$@"\n\
' > /usr/local/bin/start-services.sh && \
    chmod +x /usr/local/bin/start-services.sh

USER jovyan

ENV MLFLOW_TRACKING_URI=http://localhost:5000

CMD ["/usr/local/bin/start-services.sh"]
