---
title: "ROS2 MoveIt 완벽 가이드: 로봇 매니퓰레이션 시작하기"
date: 2025-11-26
author: botgymc
tags: [ROS2, MoveIt, 로봇, 매니퓰레이션, 모션플래닝, 튜토리얼]
---

# ROS2 MoveIt 완벽 가이드

MoveIt은 ROS 생태계에서 가장 널리 사용되는 로봇 매니퓰레이션 플랫폼입니다. 이 가이드에서는 ROS2 환경에서 MoveIt을 설치하고 사용하는 방법을 자세히 알아봅니다.

## MoveIt이란?

MoveIt은 로봇 팔(manipulator)의 모션 플래닝, 충돌 회피, 그리고 조작 기능을 제공하는 오픈소스 소프트웨어입니다. 다음과 같은 기능을 제공합니다:

- **모션 플래닝(Motion Planning)**: 로봇이 현재 위치에서 목표 위치까지 이동하는 경로를 계산
- **충돌 감지(Collision Detection)**: 로봇이 주변 환경이나 자신과 충돌하는지 확인
- **역기구학(Inverse Kinematics)**: 목표 위치를 달성하기 위한 관절 각도 계산
- **그래스핑(Grasping)**: 물체를 잡는 동작 계획

## 설치 준비사항

MoveIt을 설치하기 전에 다음 요구사항을 확인하세요:

- **Ubuntu 22.04** 또는 **24.04**
- **ROS2 Humble** 또는 **Jazzy** 설치 완료
- 최소 8GB RAM 권장

## 1단계: MoveIt 설치

### 바이너리 패키지로 설치 (권장)

가장 간단한 방법은 apt를 사용한 바이너리 설치입니다.

```bash
# ROS2 Jazzy 사용자
sudo apt update
sudo apt install ros-jazzy-moveit

# ROS2 Humble 사용자
sudo apt update
sudo apt install ros-humble-moveit
```

### 소스에서 빌드 (개발자용)

최신 기능이 필요하거나 코드 수정이 필요한 경우 소스에서 빌드합니다.

```bash
# 워크스페이스 생성
mkdir -p ~/ws_moveit/src
cd ~/ws_moveit/src

# MoveIt 소스 클론
git clone https://github.com/moveit/moveit2.git -b main

# 의존성 설치
cd ~/ws_moveit
rosdep install --from-paths src --ignore-src -r -y

# 빌드
colcon build --cmake-args -DCMAKE_BUILD_TYPE=Release
```

## 2단계: MoveIt 튜토리얼 패키지 설치

MoveIt의 기능을 배우기 위해 튜토리얼 패키지를 설치합니다.

```bash
# Jazzy 버전
sudo apt install ros-jazzy-moveit-tutorials

# Humble 버전
sudo apt install ros-humble-moveit-tutorials
```

## 3단계: 첫 번째 MoveIt 데모 실행

Panda 로봇을 사용한 기본 데모를 실행해봅시다.

```bash
# ROS2 환경 설정 (Jazzy 예시)
source /opt/ros/jazzy/setup.bash

# MoveIt 데모 실행
ros2 launch moveit2_tutorials demo.launch.py
```

RViz가 실행되면서 Panda 로봇 팔이 표시됩니다.

## MoveIt 아키텍처 이해하기

MoveIt은 여러 주요 컴포넌트로 구성됩니다:

| 컴포넌트 | 역할 |
|----------|------|
| **Move Group** | 모션 플래닝과 실행을 담당하는 메인 인터페이스 |
| **Planning Scene** | 로봇과 주변 환경 상태를 관리 |
| **Planner** | 경로 계획 알고리즘 (OMPL, CHOMP 등) |
| **Controller** | 계획된 경로를 실제 로봇에 전송 |

## Python을 이용한 MoveIt 프로그래밍

### 기본 모션 플래닝 예제

```python
#!/usr/bin/env python3
import rclpy
from rclpy.node import Node
from moveit.planning import MoveItPy
from geometry_msgs.msg import PoseStamped

class MoveItExample(Node):
    def __init__(self):
        super().__init__('moveit_example')
        
        # MoveItPy 초기화
        self.moveit = MoveItPy(node_name="moveit_py")
        self.panda_arm = self.moveit.get_planning_component("panda_arm")
        
    def move_to_pose(self, x, y, z):
        """목표 위치로 로봇 팔 이동"""
        # 목표 포즈 설정
        goal_pose = PoseStamped()
        goal_pose.header.frame_id = "panda_link0"
        goal_pose.header.stamp = self.get_clock().now().to_msg()
        goal_pose.pose.position.x = x
        goal_pose.pose.position.y = y
        goal_pose.pose.position.z = z
        goal_pose.pose.orientation.w = 1.0
        
        # 목표 설정 및 계획
        self.panda_arm.set_goal_state(pose_stamped_msg=goal_pose, 
                                       pose_link="panda_link8")
        
        # 모션 플래닝
        plan_result = self.panda_arm.plan()
        
        if plan_result:
            self.get_logger().info("플래닝 성공!")
            # 실행
            self.moveit.execute(plan_result.trajectory, 
                               controllers=[])
        else:
            self.get_logger().error("플래닝 실패!")

def main():
    rclpy.init()
    node = MoveItExample()
    
    # 목표 위치로 이동
    node.move_to_pose(0.5, 0.0, 0.5)
    
    rclpy.shutdown()

if __name__ == '__main__':
    main()
```

### Joint 목표로 이동하기

```python
#!/usr/bin/env python3
import rclpy
from rclpy.node import Node
from moveit.planning import MoveItPy

class JointMoveExample(Node):
    def __init__(self):
        super().__init__('joint_move_example')
        
        self.moveit = MoveItPy(node_name="moveit_py")
        self.panda_arm = self.moveit.get_planning_component("panda_arm")
        
    def move_to_joint_positions(self, joint_positions):
        """지정된 관절 각도로 이동"""
        robot_model = self.moveit.get_robot_model()
        robot_state = self.moveit.get_robot_state()
        
        # 관절 위치 설정
        robot_state.set_joint_group_positions("panda_arm", joint_positions)
        
        # 목표 설정
        self.panda_arm.set_goal_state(robot_state=robot_state)
        
        # 계획 및 실행
        plan_result = self.panda_arm.plan()
        
        if plan_result:
            self.get_logger().info("관절 이동 성공!")
            self.moveit.execute(plan_result.trajectory, controllers=[])
        else:
            self.get_logger().error("관절 이동 실패!")

def main():
    rclpy.init()
    node = JointMoveExample()
    
    # 7개 관절의 목표 각도 (라디안)
    joint_goals = [0.0, -0.785, 0.0, -2.356, 0.0, 1.571, 0.785]
    node.move_to_joint_positions(joint_goals)
    
    rclpy.shutdown()

if __name__ == '__main__':
    main()
```

## 충돌 회피 설정

MoveIt은 자동으로 충돌을 감지하고 회피합니다. 환경에 장애물을 추가하는 방법입니다:

```python
from moveit_msgs.msg import CollisionObject
from shape_msgs.msg import SolidPrimitive
from geometry_msgs.msg import Pose

def add_box_to_scene(planning_scene_interface, box_name, position, size):
    """Planning Scene에 박스 장애물 추가"""
    collision_object = CollisionObject()
    collision_object.header.frame_id = "panda_link0"
    collision_object.id = box_name
    
    # 박스 크기 정의
    box = SolidPrimitive()
    box.type = SolidPrimitive.BOX
    box.dimensions = size  # [x, y, z]
    
    # 박스 위치 정의
    box_pose = Pose()
    box_pose.position.x = position[0]
    box_pose.position.y = position[1]
    box_pose.position.z = position[2]
    box_pose.orientation.w = 1.0
    
    collision_object.primitives.append(box)
    collision_object.primitive_poses.append(box_pose)
    collision_object.operation = CollisionObject.ADD
    
    planning_scene_interface.apply_collision_object(collision_object)
```

## 자주 사용되는 MoveIt 명령어

| 명령어 | 설명 |
|--------|------|
| `ros2 launch moveit_setup_assistant setup_assistant.launch.py` | MoveIt 설정 도우미 실행 |
| `ros2 launch <robot>_moveit_config demo.launch.py` | 로봇 MoveIt 데모 실행 |

MoveIt 관련 토픽 및 서비스를 확인하려면:

```bash
# MoveIt 관련 토픽 확인
ros2 topic list | grep move_group

# MoveIt 관련 서비스 확인
ros2 service list | grep move_group
```

## 문제 해결 가이드

### 일반적인 오류와 해결 방법

**1. "Unable to construct robot model" 오류**
```bash
# URDF 및 SRDF 파일 확인
ros2 param get /move_group robot_description
```

**2. "No valid inverse kinematics solution" 오류**
- 목표 위치가 로봇의 작업 공간 내에 있는지 확인
- 관절 제한 범위 확인

**3. "Planning failed" 오류**
- Planning Scene에 충돌 객체 확인
- 시작 상태가 유효한지 확인
- 플래닝 시간 증가 시도

## 💡 팁과 권장사항

1. **항상 시뮬레이션에서 먼저 테스트**: 실제 로봇에 적용하기 전에 Gazebo나 RViz에서 충분히 테스트하세요.

2. **적절한 플래너 선택**: 
   - OMPL: 일반적인 모션 플래닝에 적합
   - CHOMP: 부드러운 경로가 필요할 때
   - Pilz: 산업용 직선 경로

3. **Planning Scene 업데이트**: 환경이 변할 때마다 Planning Scene을 업데이트하세요.

4. **경로 검증**: 실행 전에 항상 계획된 경로를 시각적으로 확인하세요.

## 결론

이 가이드에서 ROS2 MoveIt의 기본 개념과 설치 방법, 그리고 간단한 프로그래밍 예제를 살펴보았습니다. MoveIt은 로봇 매니퓰레이션을 위한 강력한 도구이며, 이를 활용하면 복잡한 로봇 팔 제어를 쉽게 구현할 수 있습니다.

다음 포스트에서는 실제 로봇에 MoveIt을 적용하고, Gazebo와 연동하여 시뮬레이션하는 방법에 대해 알아보겠습니다.

## 참고 자료

- [MoveIt 공식 문서](https://moveit.picknik.ai/)
- [MoveIt 튜토리얼](https://moveit.picknik.ai/main/doc/tutorials/tutorials.html)
- [MoveIt GitHub 저장소](https://github.com/moveit/moveit2)
- [ROS2 공식 문서](https://docs.ros.org/)
