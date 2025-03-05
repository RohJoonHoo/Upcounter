# 8-Bit Adder with Stopwatch Functionality (8비트 에더 및 스톱워치 기능)

## 📁 프로젝트 개요
이 프로젝트는 Verilog를 사용하여 구조적으로 설계된 8비트 에더(Adder)와 스톱워치 기능을 포함한 카운터(counter) 모듈을 구현한 것입니다. 설계는 FPGA 보드(Basys-3)에서 10진수 출력이 가능하도록 구현되었습니다.

---

## 🛠️ 설계 구조
### 스톱워치 기능을 갖춘 카운터 (Counter)
- **업 카운터 (Up Counter)**: 10Hz 주파수로 1씩 증가
- **Run/Stop 기능 (SW[0])**: `SW[0]` 스위치를 통해 시간이 멈추거나 진행됩니다.
- **Clear 기능 (SW[1])**: `SW[1]`이 1일 때 카운터를 초기화합니다.
- **7-Segment Display 출력**: FND (fnd_controller.v) 모듈을 사용하여 현재 카운터 값을 표시합니다.

---

## 🎯 기능
- **이진수 입력 및 10진수 출력**: 8비트 이진수를 입력받아 10진수로 출력
- **스톱워치 기능**: 실시간 카운트 증가 및 정지, 초기화 기능 제공
- **FPGA 호환성**: Basys-3 FPGA 보드에서 테스트 가능

---

## 🔗 사용법
1. `sources/new` 디렉터리 내 Verilog 파일을 다운로드합니다.
2. FPGA 개발 환경 (예: Xilinx Vivado)에서 프로젝트를 생성하고 `.xdc` 파일을 사용해 핀 매핑을 설정합니다.
3. `SW[0]`과 `SW[1]`을 활용하여 스톱워치 기능을 제어합니다.
4. 7-Segment Display를 통해 10진수로 출력되는 결과를 확인합니다.

---

## 📂 파일 구성
```
├── constrs1/new
│   └── basys-3.xdc          # FPGA 핀 매핑 파일
├── sources/new
│   ├── fnd_controller.v     # FND 제어 모듈
│   └── counter.v            # 스톱워치 기능 포함 업 카운터 모듈
└── README.md                # 프로젝트 설명서
```

---

## 💡 추가 정보
- FPGA 보드 설정에 따라 핀 매핑을 정확하게 설정해야 합니다.
- 시뮬레이션을 통한 검증을 위해 Testbench 파일을 활용할 수 있습니다.
