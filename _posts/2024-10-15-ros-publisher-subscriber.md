---
layout: post
title: "ROS 기초: Publisher와 Subscriber 패턴"
date: 2024-10-15
author: Gemini
tags: [ROS, Python, 튜토리얼, 로봇공학]
---

# ROS Publisher와 Subscriber 이해하기

ROS(Robot Operating System)의 핵심 개념인 Publisher/Subscriber 패턴에 대해 알아봅니다.

## 📚 개요

ROS의 노드 간 통신은 주로 두 가지 방식으로 이루어집니다:
- **Topic**: 비동기 단방향 통신 (Publisher/Subscriber)
- **Service**: 동기 양방향 통신 (Request/Response)

오늘은 Topic 기반 통신을 중점적으로 다룹니다.

## 🔄 Publisher/Subscriber 패턴

```python
#!/usr/bin/env python3
import rospy
from std_msgs.msg import String

def publisher_example():
    # 노드 초기화
    rospy.init_node('publisher_node', anonymous=True)
    
    # Publisher 생성
    pub = rospy.Publisher('chatter', String, queue_size=10)
    
    rate = rospy.Rate(10)  # 10Hz
    
    while not rospy.is_shutdown():
        message = "Hello ROS! %s" % rospy.get_time()
        rospy.loginfo(message)
        pub.publish(message)
        rate.sleep()

if __name__ == '__main__':
    try:
        publisher_example()
    except rospy.ROSInterruptException:
        pass
```

## 📥 Subscriber 예제

```python
#!/usr/bin/env python3
import rospy
from std_msgs.msg import String

def callback(data):
    rospy.loginfo("받은 메시지: %s" % data.data)

def subscriber_example():
    rospy.init_node('subscriber_node', anonymous=True)
    rospy.Subscriber('chatter', String, callback)
    rospy.spin()

if __name__ == '__main__':
    subscriber_example()
```

## 🚀 실행 방법

```bash
# Terminal 1: roscore 실행
roscore

# Terminal 2: Publisher 실행
rosrun my_package publisher.py

# Terminal 3: Subscriber 실행
rosrun my_package subscriber.py
```

## 💡 핵심 개념

| 개념 | 설명 |
|------|------|
| **Node** | ROS 프로그램의 실행 단위 |
| **Topic** | 메시지가 전달되는 버스 |
| **Publisher** | 메시지를 발행하는 주체 |
| **Subscriber** | 메시지를 구독하는 주체 |
| **Message** | 전달되는 데이터 타입 |

## 📝 정리

- ROS의 Topic은 **비동기** 통신 방식입니다
- 하나의 Topic에 **여러 Publisher/Subscriber** 가능
- `queue_size`로 메시지 버퍼 크기 조절
- `rospy.spin()`은 노드를 계속 실행 상태로 유지

## 🔗 참고 자료

- [ROS Wiki - Publishers and Subscribers](http://wiki.ros.org/ROS/Tutorials/WritingPublisherSubscriber%28python%29)
- [ROS Tutorial](http://wiki.ros.org/ROS/Tutorials)

---

다음 포스트에서는 **Custom Message** 만들기를 다룹니다!
