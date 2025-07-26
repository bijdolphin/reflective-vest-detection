# =============================================================================
# FINALIZED Dockerfile for a FULL-FEATURED FiftyOne Development Environment
#
# This version uses the standard python image (not slim) for maximum
# convenience and out-of-the-box compatibility, ideal for development.
# =============================================================================

# -----------------------------------------------------------------------------
# STEP 1: ESTABLISH THE BASE IMAGE (THE ONLY MAJOR CHANGE)
# -----------------------------------------------------------------------------
# We now use the standard 'bookworm' image. It's larger but includes many
# common tools and libraries, reducing the chance of environment-related errors.
FROM python:3.10-bookworm

# -----------------------------------------------------------------------------
# STEP 2: CONFIGURE THE BUILD ENVIRONMENT
# -----------------------------------------------------------------------------
ENV DEBIAN_FRONTEND=noninteractive

# -----------------------------------------------------------------------------
# STEP 3: INSTALL ALL SYSTEM-LEVEL DEPENDENCIES
# -----------------------------------------------------------------------------
# We keep these explicit declarations to ensure all dependencies are met,
# even if some are already included in the base image. This is a robust practice.
RUN apt-get update && apt-get install -y --no-install-recommends \
    # --- Build-time tools for Python packages ---
    build-essential \
    python3-dev \
    cmake \
    pkg-config \
    \
    # --- Core FiftyOne runtime dependencies (Expanded) ---
    git \
    ffmpeg \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    \
    # --- Remote access and file transfer dependencies ---
    openssh-server \
    curl \
    wget \
    \
    # --- Google Cloud SDK dependencies ---
    apt-transport-https \
    ca-certificates \
    gnupg \
    \
    # --- Cleanup before adding new repository ---
    && rm -rf /var/lib/apt/lists/* \
    \
    # --- Add Google Cloud SDK repository and install gcloud-cli ---
    && echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
    && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg \
    && apt-get update && apt-get install -y google-cloud-cli \
    \
    # --- Final Cleanup ---
    && rm -rf /var/lib/apt/lists/*

# -----------------------------------------------------------------------------
# STEP 4: INSTALL PYTHON DEPENDENCIES
# -----------------------------------------------------------------------------
COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# -----------------------------------------------------------------------------
# STEP 5: CONFIGURE SSH AND EXPOSE PORTS
# -----------------------------------------------------------------------------
# Ensure SCP/SFTP works out of the box.
RUN echo 'Subsystem sftp internal-sftp' >> /etc/ssh/sshd_config && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Expose standard ports
EXPOSE 22
EXPOSE 5151
EXPOSE 8888

# -----------------------------------------------------------------------------
# STEP 6: COPY PROJECT FILES AND SET UP WORKSPACE
# -----------------------------------------------------------------------------
WORKDIR /workspace
COPY . /app

# -----------------------------------------------------------------------------
# STEP 7: DEFINE THE CONTAINER'S STARTUP COMMAND
# -----------------------------------------------------------------------------
WORKDIR /app
RUN chmod +x /app/start.sh
ENTRYPOINT ["/app/start.sh"]