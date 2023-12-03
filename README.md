## 일조일항의 api 서버입니다.

- ruby 3.2.2
- rails 7.1.2
- DB: postgresql
- formatter: rufo

---

Image Upload with Carrierwave, fog, S3, CloudFront  
Before start the server, you need to install 'imagemagick'

```
brew install imagemagick
```

---

### OPEN API

1. 중앙선거관리위원회 코드정보
   [중앙선거관리위원회 코드정보](https://www.data.go.kr/data/15000897/openapi.do)

2. 중앙선거관리위원회 후보자 정보 호출
   [중앙선거관리위원회 후보자 정보](https://www.data.go.kr/tcs/dss/selectApiDataDetailView.do?publicDataPk=15000908)

3. 선거 공약 호출
   [중앙선거관리위원회 선거공약정보](https://www.data.go.kr/data/15040587/openapi.do#tab_layer_detail_function)

4. 활동중인 의원 정보 호출
   [열린국회정보](https://open.assembly.go.kr/portal/data/service/selectAPIServicePage.do/OWSSC6001134T516707#none)
