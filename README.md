Daydream(백일몽)
================

KWC 대비용 게임제작

SharedObject 데이터 형식
------------
mapCode : 맵 번호

charX, charY : 캐릭터 좌표

event : 이벤트 정보 오브젝트(Boolean)

itemPosition : 아이템 좌표 배열

{mapCode, itemCode, x, y, scale}

slot1, slot2, slotUpgrade : 아이템 슬롯 관련 정보

Known Bugs
----------
- 하향 점프시 HoldPoint 관련 오류 발생
- 사다리에서 올라갔다 떨어졌다 반복하는 현상
- 복잡한 벡터가 있는 맵에서 버벅임 현상 발생
