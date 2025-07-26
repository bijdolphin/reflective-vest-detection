#!/bin/bash

# ===========================================================================
# 环境初始化脚本 for FiftyOne 数据预处理 on RunPod
# ===========================================================================
# 此脚本旨在创建一个持久化、可远程访问的开发环境。
# 核心是JupyterLab，您可以在其中运行FiftyOne代码，进行数据下载、
# 清洗、筛选和预处理等任务。

# 步骤 1: 启动 SSH 服务
# --------------------------
# 启动sshd守护进程，允许通过SSH连接到容器进行终端操作。
# 端口已在Dockerfile中通过 `EXPOSE 22` 暴露。
echo "Starting SSH service..."
service ssh start

# 步骤 2: 启动 JupyterLab
# --------------------------
# 这是此环境的主要入口点。
#
# --ip=0.0.0.0: 监听所有网络接口，允许从容器外部访问JupyterLab。
# --port=8888: 在标准端口8888上运行。
# --allow-root: Docker容器默认以root用户运行，此标志是必需的。
# --no-browser: 在服务器环境中，我们不希望它自动尝试打开浏览器。
# --NotebookApp.token='': 禁用token认证，方便在RunPod等受控环境中直接访问。
# --notebook-dir=/workspace: 将Jupyter的工作目录设置为/workspace。
#                           这是RunPod的持久化存储卷，确保您的工作在重启后不会丢失。
echo "Starting JupyterLab on port 8888..."
echo "Your work should be saved in the /workspace directory to ensure it persists."
jupyter lab \
    --ip=0.0.0.0 \
    --port=8888 \
    --allow-root \
    --no-browser \
    --NotebookApp.token='' \
    --notebook-dir=/workspace

# ===========================================================================
# 如何在JupyterLab中使用FiftyOne App?
# ===========================================================================
# 1. 通过RunPod的连接按钮进入JupyterLab。
# 2. 打开一个新的Notebook (.ipynb) 文件。
# 3. 在代码中加载或创建您的FiftyOne数据集。
# 4. 当您需要启动FiftyOne App进行可视化时，这是最关键的一步：
#    必须在 launch_app() 中指定 address="0.0.0.0"，否则您将无法从本地浏览器访问它。
#
#    示例代码:
#    import fiftyone as fo
#    import fiftyone.zoo as foz
#
#    # 加载一个数据集
#    dataset = foz.load_zoo_dataset("quickstart")
#
#    # 启动App，允许外部连接
#    session = fo.launch_app(dataset, address="0.0.0.0", port=5151)
#
# 5. 在RunPod的 "My Pods" 页面，将容器的5151端口映射到一个HTTP公网端口，
#    然后通过该链接访问FiftyOne App。
# ===========================================================================