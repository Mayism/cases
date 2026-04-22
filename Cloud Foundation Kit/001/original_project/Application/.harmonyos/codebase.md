# HarmonyOS Administrative Affairs - Codebase Analysis

## 1. Project Overview

HarmonyOS Atomic Service for medical insurance services, v1.0.2.
ArkTS/ArkUI, SDK 5.0.4(16), multi-HSP modular architecture.

- bundleName: com.atomicservice.6917566854519018350
- bundleType: atomicService, Target: Phone only
- Dependency: @ohos/axios ^2.2.4

## 2. Directory Tree (excluding oh_modules/.idea/.hvigor)

See full analysis in the response above.

## 3. Module Dependency Graph

entry -> home, mine, service, information, common, components
home -> common, components
mine -> automatic_association_count, common, components
service -> common, components
information -> common, components
common -> automatic_association_count
components -> automatic_association_count, common
automatic_association_count -> (none)

## 4. Entry Points

- EntryAbility.ets: UIAbility, widget router, push token, full-screen setup
- Index.ets: @Entry @ComponentV2, Navigation+Tabs, NavPathStack @Provider
- EntryFormAbility.ets: Widget form lifecycle

## 5. Routing (NavPathStack)

14 named routes: business, web, reservation, record, medicines, progress,
setting, older, medicalCode, notAvailable, aboutUs, suggestion, serviceSearch, feedback

## 6. Tabs: Home(0), Service(1), MedicalCode(2), Information(3), Mine(4)

## 7. Performance Optimizations

- LazyForEach x3 (InstitutionsPage, OnlineReservation, InformationsList)
- LazyDataSource with filter/search
- AppStorage caching
- Emitter data communication
- syncLoad(false) for images
- Pull-to-refresh + infinite scroll
