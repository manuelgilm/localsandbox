#!/bin/bash
set -e

# Start MLflow server in the background with allowed hosts
export MLFLOW_SERVER_ALLOWED_HOSTS=*
mlflow server --host 0.0.0.0 --port 5000 \
  --backend-store-uri sqlite:///mlflow/mlflow.db \
  --default-artifact-root /mlflow/artifacts \
  --serve-artifacts &

# Start Jupyter
exec start-notebook.sh "$@"
