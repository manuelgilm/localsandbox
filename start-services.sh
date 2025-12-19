#!/bin/bash
set -e

# Start MLflow server in the background
mlflow server --host 0.0.0.0 --port 5000 \
  --backend-store-uri sqlite:///mlflow/mlflow.db \
  --default-artifact-root /mlflow/artifacts \
  --serve-artifacts --gunicorn-opts "--timeout 120" &

# Start Jupyter
exec start-notebook.sh "$@"
