# room exit

# 진행사항
## 2021.11.23(화)
- 방 만들기, 힌트보기, 메신저 구현완료
- 푸시 알림 launcher_icon 해결하는 중
- 힌트 다시보기 구현 필요

## 2021.11.24(수)
- 채팅시 상대방에게 알림을 주기 위해 토큰값을 알고 있어야 하는데, 이 값은 언제 저장하는게 좋을까?
- 관리자의 경우 게임시작 버튼을 누를 때 해당 토큰을 저장하도록 하고,
- 사용자의 경우 방에 입장할 때 토큰 저장하도록 구
- 메시지 보낼 때 토큰리스트 어떻게 가져올지 고민해볼 것

## 2021.11.25(목)
- 메신저 기능 구현 완료 (메시지 전송시 상대방 토큰으로만 푸시 알림)
- 앱아이콘 적용
- (완료) 힌트보기 눌렀을 때 같은 힌트면 카운트 안되도록...
- (완료) 메신저 창에서 관리자 삭제버튼이 겹쳐 있는 것 없애기
- (완료) 방 만들 때 룸타입 말고 테마 선택으로
- (완료) 방 만들 때 시간, 힌트개수 직접 입력 가능하도록 변경 (방만들기 버튼 누르면 문자열 있으면 수정하라고 팝업)
- (완료) 관리자는 힌트보기 안되도록
- (완료) 관리자가 방 삭제를 눌렀을 때 리얼타임 디비에 모든 코드를 초기화시켜주는 작업도 넣을 것
- 대기실에서 stream으로 읽으면 사용량이 커지므로 get 으로 변경해볼 것

## 2021.11.26(금)
- 시간 추가하는 부분 구현 중

## 2021.11.28(일)
- 시간 추가 및 사용자에게 알림 (새로고침 눌러주세요)
- 힌트 보기 기능 (title, content, correct 영역), 힌트 다시 보기 기능 구현 완료

## 2021.11.30(화)
- 힌트/정답보기 공백 추가 (화면높이만큼)
- 힌트보기시 비밀번호 입력창 띄우기
- 타이머 10초마다 실행
- 힌트/정답 이미지도 등록 가능하도록 변경

## 2021.12.01(수)
- 비밀번호 팝업창이 뜨면 키보드도 동시에 띄워주기
- 대기실에서 방의 정보는 테마명만 보이도록
- 방에 입장 후 뒤로가기 버튼 막기

## 2022.05.25(수)
- 수신 안되는 부분 해결 중

## 2022.05.26(목)
- 대기실 방 목록 User 표시 추가
- 방 안에서 메신저탭이 아닌 다른탭 누른 경우 키보드 내려주기

## 기능 요구사항 상세
- 회원가입, 로그인 : 자동로그인
- (관리자) 방 만들기 : 시간, 제공힌트수, 테마
- 테마별 룸 입장하기 : 비밀번호 입력으로 들어갈 것
    - 남은 시간 변경 가능하도록 해야 할지?
    - 힌트 수는 최초에 몇 개 지급이 되는 것인지, 단순히 사용한 힌트 수만 늘려주면 되는 것인지?
- 메신저 :

=> 힌트 보기시 Realtime Database 동작 소스
  final DatabaseReference db = FirebaseDatabase().reference();
  db.child('thema1').once().then((DataSnapshot result) => print('result = ${result.value['room_A']}'));

## 전체 화면 구성
- [힌트] : 현재 인원모집 중인(풀방 포함) 모든 방의 목록을 보여주기 (리스트 및 캘린더 형태, 탭하여 두 가지 보여주기 방식을 변경 가능)
    -
    -
- [메신저] : 내가 참여 중인 방을 일정 최신순으로 보여주기
    -
- [힌트 다시보기] : 내 가입정보 등이 나오는 화면
    -

## 방탈출 힌트보기 앱 시나리오
- (관리자)
    - 사용자 앱을 실행시키고 게임을 진행할 테마를 선택 후 비밀번호를 눌러 입장한다.
    - 입장과 동시에 해당 아이디로 관리자와의 채팅방이 자동 개설됨
    - 이후 관리자는
- 사용자