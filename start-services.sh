#!/bin/bash
set -e

# Create a script to start MLflow after Jupyter setup completes
cat > /tmp/start-mlflow.sh << 'EOF'
#!/bin/bash
sleep 5  # Wait for Jupyter to finish setup
export MLFLOW_SERVER_ALLOWED_HOSTS=*
mlflow server --host 0.0.0.0 --port 5000 \
  --backend-store-uri sqlite:///mlflow/mlflow.db \
  --default-artifact-root /mlflow/artifacts \
  --serve-artifacts
EOF
chmod +x /tmp/start-mlflow.sh

# Start MLflow in background
/tmp/start-mlflow.sh &

# Start Jupyter (this will fix permissions via CHOWN_EXTRA)
exec start-notebook.sh "$@"
