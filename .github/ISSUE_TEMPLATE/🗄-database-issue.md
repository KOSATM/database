---
name: "\U0001F5C4 Database Issue"
about: DB 스키마 / DDL / ERD / 쿼리 성능 관련 이슈
title: "[DB] 작업명을 입력해주세요"
labels: database
assignees: ''

---

## 📌 작업 목적
- 

## 🧩 상세 작업 내용

-   [ ] 테이블 생성 / 수정
-   [ ] PK / FK / INDEX 조정
-   [ ] ENUM / TYPE 추가
-   [ ] pgvector 컬럼 설계 (embedding 등)
-   [ ] 마이그레이션 스크립트 작성
-   [ ] ERD 업데이트

### 변경되는 스키마 (DDL)

``` sql
-- 변경될 SQL을 여기에 작성
```

### 영향 범위 분석

-   API 영향:
-   MyBatis Mapper 영향:
-   기존 데이터 영향:
-   TravelPlan / Snapshot 영향:

## 🔗 참고 자료

-   ERDCloud 링크:
-   현재 스키마 버전:

## 🧪 테스트 기준

-   [ ] DDL 실행 오류 없음\
-   [ ] FK / UNIQUE / CHECK 제약 정상 작동\
-   [ ] vector extension 정상 작동\
-   [ ] 기존 데이터 손상 없음\
-   [ ] 쿼리 성능 문제 없음

## 🔀 브랜치 네이밍 규칙

`feature/db-작업명`\
예: `feature/db-add-checklist-relations`

## 📅 예상 작업 기간

-   시작:
-   종료:
