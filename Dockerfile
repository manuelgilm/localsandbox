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

# Create directories for data, mlflow, and work with open permissions
RUN mkdir -p /mlflow/artifacts /home/jovyan/work /data && \
    chown -R jovyan:users /mlflow /home/jovyan/work /data && \
    chmod -R 777 /mlflow /data

# Define volumes
VOLUME /mlflow
VOLUME /home/jovyan/work
VOLUME /data

# Copy startup script
COPY start-services.sh /usr/local/bin/start-services.sh
RUN chmod +x /usr/local/bin/start-services.sh

# Grant sudo without password for jovyan user to fix permissions
RUN apt-get update && apt-get install -y sudo && \
    echo "jovyan ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    rm -rf /var/lib/apt/lists/*

USER jovyan

WORKDIR /home/jovyan/work

# Expose ports for Jupyter and MLflow
EXPOSE 8888 5000

ENV MLFLOW_TRACKING_URI=http://localhost:5000
ENV CHOWN_EXTRA="/mlflow,/data"
ENV CHOWN_EXTRA_OPTS="-R"

CMD ["/usr/local/bin/start-services.sh"]
