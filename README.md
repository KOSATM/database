# 📦 Database Repository (PostgreSQL)

이 레포는 **Find My Seoul 프로젝트의 공식 PostgreSQL 스키마 및 버전 관리용 저장소**입니다.  
애플리케이션 코드와 분리하여 **DB 스키마를 독립적으로 추적·관리**합니다.

## 🏛 구성 개요

```
database/
├── schema/
│   └── 001_init.sql
├── migration/
│   └── Vxxx__change.sql
└── README.md
```

## 🧩 개념 정리

### ✔ schema/001_init.sql
- 전체 DB 구조를 정의한 초기 스키마
- 새 DB 만들 때 단 1회 실행

### ✔ migration/
- 스키마 변경 이력 기록
- 순서대로 실행하여 동일한 변경 재현 가능

## 🚀 사용 방법

### 1) PostgreSQL DB 생성
```
psql -U postgres -c "CREATE DATABASE findmyseoul;"
```

### 2) 초기 스키마 적용
```
psql -U postgres -d findmyseoul -f schema/001_init.sql
```

## 🔄 스키마 버전업 흐름

1. 브랜치 생성  
2. 로컬에서 ALTER TABLE 테스트  
3. migration/Vxxx__something.sql 파일 생성  
4. schema/001_init.sql 에도 동일 반영

## 📌 브랜치 네이밍 규칙

```
menu/type/feature-name
```

menu = schema, migration, query, seed, common  
type = feat, fix, refactor, docs 등

예:
```
schema/feat/add-hotel-table
migration/fix/update-user-email-index
```

## 🏷 자동 라벨링

브랜치 이름 기반으로 `menu` 라벨 + `type` 라벨 자동 생성 및 부착

## 🔒 주의사항

- init.sql 은 항상 최신 구조 유지  
- init.sql 수정 시 migration 파일도 반드시 추가  
- migration 파일은 삭제 금지

## 🎉 끝!
