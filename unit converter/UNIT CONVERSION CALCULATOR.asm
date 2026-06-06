.data
    f0_0:              .float 0.0
    f32:               .float 32.0
    f1_8:              .float 1.8
    f5_9:              .float 0.5555556
    f273_15:           .float 273.15

    f0_92:             .float 0.92
    f1_087:            .float 1.087
    f0_79:             .float 0.79
    f1_27:             .float 1.27
    f0_86:             .float 0.86
    f1_16:             .float 1.16

    f1000:             .float 1000.0
    f100:              .float 100.0
    f3_28084:          .float 3.28084
    f39_3701:          .float 39.3701
    f0_621371:         .float 0.621371
    f1_60934:          .float 1.60934

    f0_264172:         .float 0.264172
    f0_033814:         .float 0.033814
    f236_588:          .float 236.588

    f2_20462:          .float 2.20462
    f0_035274:         .float 0.035274
    f16:               .float 16.0
    f0_157473:         .float 0.157473

    f3_6:              .float 3.6
    f0_3048:           .float 0.3048
    f2_23694:          .float 2.23694

    f4_184:            .float 4.184
    f3600000:          .float 3600000.0
    f3600:             .float 3600.0
    f1055_06:          .float 1055.06
    f1_602e_19:        .float 1.6021766e-19

    f101325:           .float 101325.0
    f100000:           .float 100000.0
    f760:              .float 760.0
    f6894_76:          .float 6894.76

    f60:               .float 60.0
    f24:               .float 24.0
    f86400:            .float 86400.0

    f1024:             .float 1024.0
    f1048576:          .float 1048576.0
    f1099511627776:    .float 1099511627776.0

    f10_7639:          .float 10.7639
    f4046_85642:       .float 4046.85642
    f2_47105:          .float 2.47105
    f10000:            .float 10000.0

    f0_0174533:        .float 0.0174533
    f57_2958:          .float 57.2958

.text
.globl main

main:
    li $v0, 5
    syscall
    move $t0, $v0

    li $v0, 5
    syscall
    move $t1, $v0

    li $v0, 6
    syscall

    beq $t0, 1, Temperature
    beq $t0, 2, Currency
    beq $t0, 3, Length
    beq $t0, 4, Volume
    beq $t0, 5, Weight
    beq $t0, 6, Speed
    beq $t0, 7, Energy
    beq $t0, 8, Pressure
    beq $t0, 9, Time
    beq $t0, 10, DataStorage
    beq $t0, 11, Area
    beq $t0, 12, Angle
    j Invalid

Temperature:
    beq $t1, 1, CtoF
    beq $t1, 2, FtoC
    beq $t1, 3, CtoK
    beq $t1, 4, KtoC
    beq $t1, 5, FtoK
    beq $t1, 6, KtoF
    j Invalid

CtoF:
    l.s $f1, f1_8
    l.s $f2, f32
    mul.s $f0, $f0, $f1
    add.s $f0, $f0, $f2
    j PrintResult

FtoC:
    l.s $f1, f32
    l.s $f2, f5_9
    sub.s $f0, $f0, $f1
    mul.s $f0, $f0, $f2
    j PrintResult

CtoK:
    l.s $f1, f273_15
    add.s $f0, $f0, $f1
    j PrintResult

KtoC:
    l.s $f1, f273_15
    sub.s $f0, $f0, $f1
    j PrintResult

FtoK:
    l.s $f1, f32
    l.s $f2, f5_9
    l.s $f3, f273_15
    sub.s $f0, $f0, $f1
    mul.s $f0, $f0, $f2
    add.s $f0, $f0, $f3
    j PrintResult

KtoF:
    l.s $f1, f273_15
    l.s $f2, f1_8
    l.s $f3, f32
    sub.s $f0, $f0, $f1
    mul.s $f0, $f0, $f2
    add.s $f0, $f0, $f3
    j PrintResult

Currency:
    beq $t1, 1, USDToEUR
    beq $t1, 2, EURToUSD
    beq $t1, 3, USDToGBP
    beq $t1, 4, GBPToUSD
    beq $t1, 5, EURToGBP
    beq $t1, 6, GBPToEUR
    j Invalid

USDToEUR:
    l.s $f1, f0_92
    j DoMul
EURToUSD:
    l.s $f1, f1_087
    j DoMul
USDToGBP:
    l.s $f1, f0_79
    j DoMul
GBPToUSD:
    l.s $f1, f1_27
    j DoMul
EURToGBP:
    l.s $f1, f0_86
    j DoMul
GBPToEUR:
    l.s $f1, f1_16
    j DoMul

Length:
    beq $t1, 1, MMToM
    beq $t1, 2, MToMM
    beq $t1, 3, CMToM
    beq $t1, 4, MToCM
    beq $t1, 5, MToFT
    beq $t1, 6, FTToM
    beq $t1, 7, MToIN
    beq $t1, 8, INToM
    beq $t1, 9, KMToMI
    beq $t1, 10, MIToKM
    j Invalid

MMToM:
    l.s $f1, f1000
    j DoDiv
MToMM:
    l.s $f1, f1000
    j DoMul
CMToM:
    l.s $f1, f100
    j DoDiv
MToCM:
    l.s $f1, f100
    j DoMul
MToFT:
    l.s $f1, f3_28084
    j DoMul
FTToM:
    l.s $f1, f3_28084
    j DoDiv
MToIN:
    l.s $f1, f39_3701
    j DoMul
INToM:
    l.s $f1, f39_3701
    j DoDiv
KMToMI:
    l.s $f1, f0_621371
    j DoMul
MIToKM:
    l.s $f1, f1_60934
    j DoMul

Volume:
    beq $t1, 1, MLToL
    beq $t1, 2, LToML
    beq $t1, 3, LToGAL
    beq $t1, 4, GALToL
    beq $t1, 5, MLToOZ
    beq $t1, 6, OZToML
    beq $t1, 7, LToM3
    beq $t1, 8, M3ToL
    beq $t1, 9, CupsToML
    beq $t1, 10, MLToCups
    j Invalid

MLToL:
    l.s $f1, f1000
    j DoDiv
LToML:
    l.s $f1, f1000
    j DoMul
LToGAL:
    l.s $f1, f0_264172
    j DoMul
GALToL:
    l.s $f1, f0_264172
    j DoDiv
MLToOZ:
    l.s $f1, f0_033814
    j DoMul
OZToML:
    l.s $f1, f0_033814
    j DoDiv
LToM3:
    l.s $f1, f1000
    j DoDiv
M3ToL:
    l.s $f1, f1000
    j DoMul
CupsToML:
    l.s $f1, f236_588
    j DoMul
MLToCups:
    l.s $f1, f236_588
    j DoDiv

Weight:
    beq $t1, 1, MGToG
    beq $t1, 2, GToMG
    beq $t1, 3, GToKG
    beq $t1, 4, KGToG
    beq $t1, 5, KGToLB
    beq $t1, 6, LBToKG
    beq $t1, 7, GToOZ
    beq $t1, 8, OZToG
    beq $t1, 9, LBToOZ
    beq $t1, 10, OZToLB
    beq $t1, 11, KGToST
    j Invalid

MGToG:
    l.s $f1, f1000
    j DoDiv
GToMG:
    l.s $f1, f1000
    j DoMul
GToKG:
    l.s $f1, f1000
    j DoDiv
KGToG:
    l.s $f1, f1000
    j DoMul
KGToLB:
    l.s $f1, f2_20462
    j DoMul
LBToKG:
    l.s $f1, f2_20462
    j DoDiv
GToOZ:
    l.s $f1, f0_035274
    j DoMul
OZToG:
    l.s $f1, f0_035274
    j DoDiv
LBToOZ:
    l.s $f1, f16
    j DoMul
OZToLB:
    l.s $f1, f16
    j DoDiv
KGToST:
    l.s $f1, f0_157473
    j DoMul

Speed:
    beq $t1, 1, MSToKMH
    beq $t1, 2, KMHToMS
    beq $t1, 3, MPHToKMH
    beq $t1, 4, KMHToMPH
    beq $t1, 5, FPSToMS
    beq $t1, 6, MSToMPH
    beq $t1, 7, MPHToMS
    j Invalid

MSToKMH:
    l.s $f1, f3_6
    j DoMul
KMHToMS:
    l.s $f1, f3_6
    j DoDiv
MPHToKMH:
    l.s $f1, f1_60934
    j DoMul
KMHToMPH:
    l.s $f1, f1_60934
    j DoDiv
FPSToMS:
    l.s $f1, f0_3048
    j DoMul
MSToMPH:
    l.s $f1, f2_23694
    j DoMul
MPHToMS:
    l.s $f1, f2_23694
    j DoDiv

Energy:
    beq $t1, 1, JToCAL
    beq $t1, 2, CALToJ
    beq $t1, 3, KWHToJ
    beq $t1, 4, JToKWH
    beq $t1, 5, WHToJ
    beq $t1, 6, JToWH
    beq $t1, 7, BTUToJ
    beq $t1, 8, JToBTU
    beq $t1, 9, EVToJ
    beq $t1, 10, JToEV
    j Invalid

JToCAL:
    l.s $f1, f4_184
    j DoDiv
CALToJ:
    l.s $f1, f4_184
    j DoMul
KWHToJ:
    l.s $f1, f3600000
    j DoMul
JToKWH:
    l.s $f1, f3600000
    j DoDiv
WHToJ:
    l.s $f1, f3600
    j DoMul
JToWH:
    l.s $f1, f3600
    j DoDiv
BTUToJ:
    l.s $f1, f1055_06
    j DoMul
JToBTU:
    l.s $f1, f1055_06
    j DoDiv
EVToJ:
    l.s $f1, f1_602e_19
    j DoMul
JToEV:
    l.s $f1, f1_602e_19
    j DoDiv

Pressure:
    beq $t1, 1, PaToATM
    beq $t1, 2, ATMToPa
    beq $t1, 3, PaToBar
    beq $t1, 4, BarToPa
    beq $t1, 5, TorrToATM
    beq $t1, 6, ATMToTorr
    beq $t1, 7, PSIToPa
    beq $t1, 8, PaToPSI
    j Invalid

PaToATM:
    l.s $f1, f101325
    j DoDiv
ATMToPa:
    l.s $f1, f101325
    j DoMul
PaToBar:
    l.s $f1, f100000
    j DoDiv
BarToPa:
    l.s $f1, f100000
    j DoMul
TorrToATM:
    l.s $f1, f760
    j DoDiv
ATMToTorr:
    l.s $f1, f760
    j DoMul
PSIToPa:
    l.s $f1, f6894_76
    j DoMul
PaToPSI:
    l.s $f1, f6894_76
    j DoDiv

Time:
    beq $t1, 1, SecToMin
    beq $t1, 2, MinToSec
    beq $t1, 3, MinToHour
    beq $t1, 4, HourToMin
    beq $t1, 5, HourToDay
    beq $t1, 6, DayToHour
    beq $t1, 7, DayToSec
    beq $t1, 8, SecToDay
    j Invalid

SecToMin:
    l.s $f1, f60
    j DoDiv
MinToSec:
    l.s $f1, f60
    j DoMul
MinToHour:
    l.s $f1, f60
    j DoDiv
HourToMin:
    l.s $f1, f60
    j DoMul
HourToDay:
    l.s $f1, f24
    j DoDiv
DayToHour:
    l.s $f1, f24
    j DoMul
DayToSec:
    l.s $f1, f86400
    j DoMul
SecToDay:
    l.s $f1, f86400
    j DoDiv

DataStorage:
    beq $t1, 1, BytesToKB
    beq $t1, 2, KBToBytes
    beq $t1, 3, KBToMB
    beq $t1, 4, MBToKB
    beq $t1, 5, MBToGB
    beq $t1, 6, GBToMB
    beq $t1, 7, GBToTB
    beq $t1, 8, TBToGB
    beq $t1, 9, BytesToMB
    beq $t1, 10, TBToBytes
    j Invalid

BytesToKB:
    l.s $f1, f1024
    j DoDiv
KBToBytes:
    l.s $f1, f1024
    j DoMul
KBToMB:
    l.s $f1, f1024
    j DoDiv
MBToKB:
    l.s $f1, f1024
    j DoMul
MBToGB:
    l.s $f1, f1024
    j DoDiv
GBToMB:
    l.s $f1, f1024
    j DoMul
GBToTB:
    l.s $f1, f1024
    j DoDiv
TBToGB:
    l.s $f1, f1024
    j DoMul
BytesToMB:
    l.s $f1, f1048576
    j DoDiv
TBToBytes:
    l.s $f1, f1099511627776
    j DoMul

Area:
    beq $t1, 1, SQMToSQFT
    beq $t1, 2, SQFTToSQM
    beq $t1, 3, SQMToAcres
    beq $t1, 4, AcresToSQM
    beq $t1, 5, HectaresToAcres
    beq $t1, 6, AcresToHectares
    beq $t1, 7, SQMToHectares
    beq $t1, 8, HectaresToSQM
    j Invalid

SQMToSQFT:
    l.s $f1, f10_7639
    j DoMul
SQFTToSQM:
    l.s $f1, f10_7639
    j DoDiv
SQMToAcres:
    l.s $f1, f4046_85642
    j DoDiv
AcresToSQM:
    l.s $f1, f4046_85642
    j DoMul
HectaresToAcres:
    l.s $f1, f2_47105
    j DoMul
AcresToHectares:
    l.s $f1, f2_47105
    j DoDiv
SQMToHectares:
    l.s $f1, f10000
    j DoDiv
HectaresToSQM:
    l.s $f1, f10000
    j DoMul

Angle:
    beq $t1, 1, DegToRad
    beq $t1, 2, RadToDeg
    j Invalid

DegToRad:
    l.s $f1, f0_0174533
    j DoMul
RadToDeg:
    l.s $f1, f57_2958
    j DoMul

DoMul:
    mul.s $f0, $f0, $f1
    j PrintResult

DoDiv:
    div.s $f0, $f0, $f1
    j PrintResult

Invalid:
    l.s $f0, f0_0
    j PrintResult

PrintResult:
    mov.s $f12, $f0
    li $v0, 2
    syscall
    li $v0, 10
    syscall