---
title: "ROS2 Jazzy와 Gazebo Harmonic 설치 완벽 가이드"
date: 2025-10-24
author: botgymc
tags: [ROS2, Gazebo, Jazzy, Harmonic, 로봇, 시뮬레이션, 튜토리얼]
---

# ROS2 Jazzy와 Gazebo Harmonic 설치하기

로봇 운영체제(ROS)와 시뮬레이터(Gazebo)는 로봇 공학 연구 및 개발에 필수적인 도구입니다. 이 가이드에서는 ROS2 Jazzy Jalisco와 최신 Gazebo 버전인 Harmonic을 Ubuntu 22.04에 설치하는 방법을 자세히 안내합니다.

## ROS2와 Gazebo 소개

- **ROS2 (Robot Operating System 2)**: 로봇 애플리케이션을 개발하기 위한 오픈소스 프레임워크입니다. 분산 시스템 아키텍처를 기반으로 하여 여러 컴퓨터 간의 통신과 협업을 지원합니다.
- **Gazebo**: 로봇을 위한 3D 동역학 시뮬레이터입니다. 실제와 유사한 환경에서 로봇의 동작을 테스트하고 알고리즘을 검증할 수 있습니다.

ROS2 Jazzy는 공식적으로 Gazebo Harmonic 버전을 지원합니다. 이 가이드는 ROS2 Jazzy와 Gazebo Harmonic을 함께 설치하는 표준 방법을 안내합니다.

## 설치 준비: 시스템 설정

본격적인 설치에 앞서, 시스템을 최신 상태로 업데이트하고 로케일 설정을 완료해야 합니다.

```bash
# 시스템 패키지 목록 업데이트 및 로케일 설치
sudo apt update && sudo apt install locales

# 로케일 생성 및 설정
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8
```

## 1단계: ROS2 Jazzy 설치

### 1. ROS2 저장소 추가

ROS2 패키지를 다운로드할 수 있도록 시스템에 ROS2 저장소를 추가합니다.

```bash
# Universe 저장소 활성화
sudo apt install software-properties-common
sudo add-apt-repository universe

# ROS2 GPG 키 추가
sudo apt update && sudo apt install curl -y
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg

# sources.list에 ROS2 저장소 추가
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null
```

### 2. ROS2 Jazzy Desktop 설치

이제 ROS2 Jazzy의 데스크톱 전체 버전을 설치합니다. 여기에는 ROS, RViz, 데모 및 튜토리얼이 포함됩니다.

```bash
sudo apt update
sudo apt upgrade
sudo apt install ros-jazzy-desktop-full
```

### 3. 환경 설정

ROS2 명령어를 터미널에서 사용하려면, `setup.bash` 파일을 셸 시작 스크립트에 추가해야 합니다.

```bash
# ROS2 환경 설정 스크립트 실행
source /opt/ros/jazzy/setup.bash

# .bashrc에 자동 실행 추가
echo "source /opt/ros/jazzy/setup.bash" >> ~/.bashrc
source ~/.bashrc
```

## 2단계: Gazebo Harmonic 설치

### 1. Gazebo 저장소 추가

Gazebo 패키지를 받기 위해 OSRF(Open Source Robotics Foundation)의 저장소를 추가합니다.

```bash
# Gazebo GPG 키 추가
sudo wget https://packages.osrfoundation.org/gazebo.gpg -O /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg

# sources.list에 Gazebo 저장소 추가
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null

sudo apt update
```

### 2. Gazebo Harmonic 설치

이제 Gazebo Harmonic을 설치합니다.

```bash
sudo apt install gz-harmonic
```

### 3. ROS2-Gazebo 통합 패키지 설치

Gazebo Harmonic과 ROS2를 연결하는 브릿지 패키지는 ROS 배포판별로 제공됩니다. Gazebo Harmonic은 ROS2 Jazzy에서 지원되는 조합이므로, 아래와 같이 `ros-jazzy-ros-gz` 패키지를 설치하세요.

```bash
sudo apt install ros-jazzy-ros-gz
```
**참고**: `ros-jazzy-ros-gz`는 Gazebo Harmonic에 맞춰 빌드된 브릿지(ros-gz) 메타 패키지입니다. 다른 배포판을 사용 중이라면 해당 배포판용 브릿지를 확인해야 합니다.

## 3단계: 설치 확인

### 1. ROS2 설치 확인

`talker`와 `listener` 노드를 실행하여 ROS2 통신이 정상적으로 작동하는지 확인합니다.

```bash
# 첫 번째 터미널
ros2 run demo_nodes_cpp talker

# 두 번째 터미널
ros2 run demo_nodes_py listener
```
`listener` 터미널에 "I heard: [Hello World: ...]" 메시지가 출력되면 성공입니다.

### 2. Gazebo Harmonic 설치 확인

Gazebo 시뮬레이터를 실행하여 정상적으로 설치되었는지 확인합니다.

```bash
gz sim -v 4 empty.sdf
```
빈 월드가 포함된 Gazebo 시뮬레이션 창이 나타나면 성공입니다.

## 추가 팁: 배포판 및 패키지 확인

특정 배포판용 브릿지 패키지 이름은 배포판에 따라 다르므로, 설치 전에 패키지 이름을 확인하세요. 예를 들어 `ros-jazzy-ros-gz` 또는 `ros-humble-ros-gz`처럼 배포판 이름이 들어갑니다.

다음 명령으로 사용 가능한 관련 패키지를 검색할 수 있습니다:

```bash
# apt로 검색 (Ubuntu)
apt search ros-*-ros-gz

# 또는 apt-cache 사용
apt-cache search ros | grep ros-gz
```

또는 시스템에 설치된 ROS 디렉터리를 확인해 현재 사용 중인 배포판을 파악하세요:

```bash
ls /opt/ros
```

출력에 표시되는 폴더 이름(예: jazzy, humble)이 해당 시스템에 설치된 ROS2 배포판입니다. 이 값을 `<distro>` 자리에 넣어 설치 명령을 실행하세요.


## 결론

이제 여러분의 시스템에 ROS2 Jazzy와 Gazebo Harmonic이 성공적으로 설치되었습니다. Gazebo Harmonic은 ROS2 Jazzy와 호환되는 조합이므로, 통합 패키지는 `ros-jazzy-ros-gz`를 사용하세요. 이 조합으로 로봇 애플리케이션을 개발하고 시뮬레이션할 준비가 되었습니다.

다음 포스트에서는 ROS2와 Gazebo를 연동하여 간단한 로봇 모델을 시뮬레이션하는 방법에 대해 알아보겠습니다.

## 참고 자료

 - [ROS2 Jazzy 공식 설치 문서](https://docs.ros.org/en/jazzy/Installation.html)
- [Gazebo Harmonic 설치 문서](https://gazebosim.org/docs/harmonic)
