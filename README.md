# 일조일항의 api 서버입니다.

## 서비스명

일조일항

iljoilhang

## 서비스 정체성

국민의 알 권리를 대상하는 정보를 제공한다.

## 타겟

각 선거일 기준 만 18세 이상의 국민, 대한민국 유권자

## 개발환경

- Ruby 3.2.2
- Ruby on Rails 7.1.2
- PostgreSQL
- Sidekiq

## 배포환경

- Ubuntu Server 22.04 LTS (HVM)
- Nginx 1.18.0

## 세팅

---

```shell
# ruby와 bundler 등 기본 개발환경 세팅이 완료 된 후, 프로젝트 clone
bundle install
rails db:create db:migrate
```

의원, 발의법안, 선거정보 데이터 바로 업데이트를 원할 경우

```shell
rails db:seed
```

---

스토리지로 Carrierwave, fog, S3, CloudFront를 이용합니다.  
서버 실행 전, 'imagemagick'를 설치해야 합니다.

```shell
# mac 유저일 경우,
brew install imagemagick
```

---

## OPEN API

1. 중앙선거관리위원회 코드정보
   [중앙선거관리위원회 코드정보](https://www.data.go.kr/data/15000897/openapi.do)

2. 중앙선거관리위원회 후보자 정보 호출
   [중앙선거관리위원회 후보자 정보](https://www.data.go.kr/tcs/dss/selectApiDataDetailView.do?publicDataPk=15000908)

3. 선거 공약 호출
   [중앙선거관리위원회 선거공약정보](https://www.data.go.kr/data/15040587/openapi.do#tab_layer_detail_function)

4. 활동중인 의원 정보 호출
   [열린국회정보 의원정보](https://open.assembly.go.kr/portal/data/service/selectAPIServicePage.do/OWSSC6001134T516707#none)

5. 발의법률안
   [열린국회정보 발의법률안](https://open.assembly.go.kr/portal/data/service/selectAPIServicePage.do/OK7XM1000938DS17215)
