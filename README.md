# Pokedex
포켓몬 도감 앱 과제

## 개발 환경
- Xcode 16.2
- macOS 15.2
- Deployment Target iOS 16.6

## 기술 스택
- UIKit, ComposableLayout, RxSwift
- MVVM

## 주요 기능
- Pokemon API를 활용, 포켓몬 목록을 보여주는 컬렉션 뷰
- 무한 스크롤

## 동작 화면
| 메인 화면 | 디테일 화면 | 무한스크롤 동작 |
| -- | -- | -- |
|<img src="https://github.com/user-attachments/assets/03b41574-9bba-4360-a803-dec56adebc7d" width=300>|<img src="https://github.com/user-attachments/assets/eacb8b16-8629-4ee2-bb74-56ab89ec2dc2" width=300>|<img src="https://github.com/user-attachments/assets/3fd16d51-d1ce-419d-9f9d-3a711d3d0891" width=300>|

## 트러블슈팅

### 문제 상황
- RxSwift 패키지 추가 이후 빌드 시 Could not find or use auto-linked library 'XCTestSwiftSupport' 오류 발생

![](https://velog.velcdn.com/images/ericyong95/post/4c16e29f-f44a-4091-906d-76ee74748d7f/image.png)

- Pokedex 타겟 빌드 과정에서 발생한 오류임을 확인

![](https://velog.velcdn.com/images/ericyong95/post/e0f93a1b-aecd-461b-8e15-8c52e2c87dee/image.png)

- 오류 메시지를 보면 RxTest에서 XCTest 프레임워크에 의존하고 있지만, 해당 프레임워크를 찾을 수 없다는 내용임.

### 원인
* Pokedex 타겟은 테스트 대상이 아니기 때문에 ENABLE_TESTING_SEARCH_PATHS 옵션이 No로 설정됨.
* 이로 인해 테스트 관련 라이브러리나 프레임워크를 컴파일하고 링크하는 데 필요한 검색 경로가 추가되지 않음.
* 따라서 XCTest를 찾을 수 없게 됨. 

### 해결 과정
- Pokedex 타겟의 ENABLE_TESTING_SEARCH_PATHS 옵션을 Yes로 설정
  - 이 설정으로 테스트 관련 라이브러리 및 프레임워크 경로를 추가해 빌드가 가능하게 할 수 있음.
  - 하지만 Pokedex는 테스트 대상이 아니므로 이 방법은 올바르지 않음.
- RxTest, RxBlocking을 Pokedex 타겟에서 제거
  - Pokedex 타겟에서 RxTest, RxBlocking을 제거하면 XCTest에 대한 의존성이 사라져 문제 해결 가능.
- 불필요한 테스트 의존성을 제거해 문제를 해결.
