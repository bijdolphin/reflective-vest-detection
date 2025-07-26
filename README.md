# Reflective Vest Data Processing Docker

反光背心数据处理的 Docker 化项目。

## 项目文件

- `Dockerfile` - Docker 镜像构建文件
- `requirements.txt` - Python 依赖包
- `requirements.lock.txt` - 锁定版本的依赖包
- `start.sh` - 启动脚本

## 使用方法

### 构建 Docker 镜像
```bash
docker build -t reflective-vest-processor .
```

### 运行容器
```bash
docker run reflective-vest-processor
```

## 开发

本项目使用 Python 开发，通过 Docker 容器化部署。


## 更新日志
- Sat Jul 26 15:00:41 CST 2025: 添加了 GitHub Actions 自动构建功能

## 更新日志
- Sat Jul 26 15:03:51 CST 2025: 添加了 GitHub Actions 自动构建功能
