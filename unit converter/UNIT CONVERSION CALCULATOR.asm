.data
    prompt:          .asciiz "\nEnter your choice: "
    invalidMsg:      .asciiz "\nInvalid choice. Please try again.\n"
    outputValue:     .asciiz "\nThe result is: "
    enterValue:      .asciiz "\nEnter the value to convert: "
    enterRate:       .asciiz "\nEnter the conversion rate: "
    repeatMsg:       .asciiz "\nDo you want to perform another conversion? (1 for Yes, 0 for No): "
    
    # Main menu and submenus
    menu:            .asciiz "\nUnit Conversion Menu:\n1. Temperature\n2. Currency\n3. Length\n4. Volume\n5. Weight\n6. Speed\n7. Energy\n8. Pressure\n9. Time\n10. Exit\n"
    tempMenu:        .asciiz "\nTemperature Conversion:\n1. Celsius to Fahrenheit\n2. Fahrenheit to Celsius\n3. Kelvin to Fahrenheit\n4. Celsius to Kelvin\n5. Fahrenheit to Kelvin\n6. Return to Main Menu\n"
    currMenu:        .asciiz "\nCurrency Conversion:\n1. USD to Euro\n2. Euro to USD\n3. USD to GBP\n4. Euro to GBP\n5. GBP to USD\n6. Return to Main Menu\n"
    lengthMenu:      .asciiz "\nLength Conversion:\n1. Meters to Feet\n2. Feet to Meters\n3. Meters to Yards\n4. Yards to Meters\n5. Meters to Inches\n6. Return to Main Menu\n"
    volumeMenu:      .asciiz "\nVolume Conversion:\n1. Liters to Gallons\n2. Gallons to Liters\n3. Milliliters to Ounces\n4. Ounces to Milliliters\n5. Liters to Cubic Meters\n6. Return to Main Menu\n"
    weightMenu:      .asciiz "\nWeight Conversion:\n1. Kilograms to Pounds\n2. Pounds to Kilograms\n3. Grams to Ounces\n4. Ounces to Grams\n5. Kilograms to Stones\n6. Return to Main Menu\n"
    speedMenu:       .asciiz "\nSpeed Conversion:\n1. Meters/Second to Kilometers/Hour\n2. Kilometers/Hour to Meters/Second\n3. Miles/Hour to Kilometers/Hour\n4. Kilometers/Hour to Miles/Hour\n5. Feet/Second to Meters/Second\n6. Return to Main Menu\n"
    energyMenu:      .asciiz "\nEnergy Conversion:\n1. Joules to Calories\n2. Calories to Joules\n3. Kilowatt-hours to Joules\n4. Joules to Kilowatt-hours\n5. Calories to Kilojoules\n6. Return to Main Menu\n"
    pressureMenu:    .asciiz "\nPressure Conversion:\n1. Pascals to Atmospheres\n2. Atmospheres to Pascals\n3. Pascals to Bar\n4. Bar to Pascals\n5. Torr to Atmospheres\n6. Return to Main Menu\n"
    timeMenu:        .asciiz "\nTime Conversion:\n1. Seconds to Minutes\n2. Minutes to Seconds\n3. Minutes to Hours\n4. Hours to Days\n5. Days to Hours\n6. Return to Main Menu\n"
    angleMenu:       .asciiz "\nAngle Conversion:\n1. Degrees to Radians\n2. Radians to Degrees\n3. Return to Main Menu\n"
    powerMenu:       .asciiz "\nPower Conversion:\n1. Watts to Kilowatts\n2. Kilowatts to Watts\n3. Watts to Horsepower\n4. Horsepower to Watts\n5. Return to Main Menu\n"
    

    # Constants for conversions
    f32_0:          .float 32.0
    f5_9:           .float 0.5555556      # 5/9
    f9_5:           .float 1.8            # 9/5
    f273_15:        .float 273.15
    f3_28084:       .float 3.28084        # meters to feet
    f1_09361:       .float 1.09361        # meters to yards
    f39_3701:       .float 39.3701        # meters to inches
    f0_264172:      .float 0.264172       # liters to gallons
    f0_033814:      .float 0.033814       # milliliters to ounces
    f2_20462:       .float 2.20462        # kilograms to pounds
    f0_157473:      .float 0.157473       # kilograms to stones
    f3_6:           .float 3.6            # m/s to km/h
    f2_23694:       .float 2.23694        # m/s to mph
    f1_60934:       .float 1.60934        # mph to km/h
    f0_3048:        .float 0.3048         # ft/s to m/s
    f4_184:         .float 4.184          # calories to joules
    f3600000:       .float 3600000.0      # kWh to joules
    f101325:        .float 101325.0       # atmospheres to pascals
    f100000:        .float 100000.0       # bar to pascals
    f760:           .float 760.0          # atmospheres to torr
    f1000_0:        .float 1000.0	  # Additional constants needed for li.s replacements
    f60:             .float 60.0             # Seconds/Minutes
    f3600:           .float 3600.0           # Seconds/Hour
    f24:             .float 24.0             # Hours/Day
    f0_0174533:      .float 0.0174533        # Degrees to Radians
    f57_2958:        .float 57.2958          # Radians to Degrees
    f0_001:          .float 0.001            # Watts to Kilowatts
    f745_7:          .float 745.7            # Horsepower to Watts

.text
.globl main

main:
    # Display main menu
    li $v0, 4
    la $a0, menu
    syscall

    # Get user choice
    li $v0, 4
    la $a0, prompt
    syscall
    li $v0, 5
    syscall
    move $t0, $v0

    # Validate input (1-10)
    blt $t0, 1, InvalidChoice
    bgt $t0, 10, InvalidChoice

    # Branch to appropriate menu
    beq $t0, 1, TemperatureMenu
    beq $t0, 2, CurrencyMenu
    beq $t0, 3, LengthMenu
    beq $t0, 4, VolumeMenu
    beq $t0, 5, WeightMenu
    beq $t0, 6, SpeedMenu
    beq $t0, 7, EnergyMenu
    beq $t0, 8, PressureMenu
    beq $t0, 9, TimeMenu
    beq $t0, 10, Exit
    beq $t0, 11, PowerMenu
    beq $t0, 12, Exit

   
InvalidChoice:
    li $v0, 4
    la $a0, invalidMsg
    syscall
    j main
TimeMenu:
    li $v0, 4
    la $a0, timeMenu
    syscall
    
    # Get user choice
    li $v0, 4
    la $a0, prompt
    syscall
    li $v0, 5
    syscall
    move $t1, $v0

    # Validate input
    blt $t1, 1, InvalidTimeChoice
    bgt $t1, 6, InvalidTimeChoice

    # Branch
    beq $t1, 1, SecToMin
    beq $t1, 2, MinToSec
    beq $t1, 3, MinToHour
    beq $t1, 4, HourToDay
    beq $t1, 5, DayToHour
    beq $t1, 6, main

InvalidTimeChoice:
    li $v0, 4
    la $a0, invalidMsg
    syscall
    j TimeMenu

# Time Conversions
SecToMin: 
    jal GetInput
    l.s $f1, f60
    div.s $f0, $f0, $f1
    j PrintResult

MinToSec: 
    jal GetInput
    l.s $f1, f60
    mul.s $f0, $f0, $f1
    j PrintResult

MinToHour: 
    jal GetInput
    l.s $f1, f60
    div.s $f0, $f0, $f1
    j PrintResult

HourToDay: 
    jal GetInput
    l.s $f1, f24
    div.s $f0, $f0, $f1
    j PrintResult

DayToHour: 
    jal GetInput
    l.s $f1, f24
    mul.s $f0, $f0, $f1
    j PrintResult
AngleMenu:
    li $v0, 4
    la $a0, angleMenu
    syscall
    
    li $v0, 4
    la $a0, prompt
    syscall
    li $v0, 5
    syscall
    move $t1, $v0

    blt $t1, 1, InvalidAngleChoice
    bgt $t1, 3, InvalidAngleChoice

    beq $t1, 1, DegToRad
    beq $t1, 2, RadToDeg
    beq $t1, 3, main

InvalidAngleChoice:
    li $v0, 4
    la $a0, invalidMsg
    syscall
    j AngleMenu

# Angle Conversions
DegToRad: 
    jal GetInput
    l.s $f1, f0_0174533
    mul.s $f0, $f0, $f1
    j PrintResult

RadToDeg: 
    jal GetInput
    l.s $f1, f57_2958
    mul.s $f0, $f0, $f1
    j PrintResult
PowerMenu:
    li $v0, 4
    la $a0, powerMenu
    syscall
    
    li $v0, 4
    la $a0, prompt
    syscall
    li $v0, 5
    syscall
    move $t1, $v0

    blt $t1, 1, InvalidPowerChoice
    bgt $t1, 5, InvalidPowerChoice

    beq $t1, 1, WtoKW
    beq $t1, 2, KWtoW
    beq $t1, 3, WtoHP
    beq $t1, 4, HPtoW
    beq $t1, 5, main

InvalidPowerChoice:
    li $v0, 4
    la $a0, invalidMsg
    syscall
    j PowerMenu

# Power Conversions
WtoKW: 
    jal GetInput
    l.s $f1, f0_001
    mul.s $f0, $f0, $f1
    j PrintResult

KWtoW: 
    jal GetInput
    l.s $f1, f0_001
    div.s $f0, $f0, $f1
    j PrintResult

WtoHP: 
    jal GetInput
    l.s $f1, f745_7
    div.s $f0, $f0, $f1
    j PrintResult

HPtoW: 
    jal GetInput
    l.s $f1, f745_7
    mul.s $f0, $f0, $f1
    j PrintResult


# Temperature Menu Section
TemperatureMenu:
    li $v0, 4
    la $a0, tempMenu
    syscall
    
    # Get subchoice
    li $v0, 4
    la $a0, prompt
    syscall
    li $v0, 5
    syscall
    move $t1, $v0

    # Validate input (1-6)
    blt $t1, 1, InvalidTempChoice
    bgt $t1, 6, InvalidTempChoice

    # Branch to conversion
    beq $t1, 1, CtoF
    beq $t1, 2, FtoC
    beq $t1, 3, KtoF
    beq $t1, 4, CtoK
    beq $t1, 5, FtoK
    beq $t1, 6, main

InvalidTempChoice:
    li $v0, 4
    la $a0, invalidMsg
    syscall
    j TemperatureMenu

# Temperature Conversions
CtoF:    # °F = (°C × 9/5) + 32
    jal GetInput
    l.s $f1, f9_5
    l.s $f2, f32_0
    mul.s $f0, $f0, $f1
    add.s $f0, $f0, $f2
    j PrintResult

FtoC:    # °C = (°F - 32) × 5/9
    jal GetInput
    l.s $f1, f32_0
    l.s $f2, f5_9
    sub.s $f0, $f0, $f1
    mul.s $f0, $f0, $f2
    j PrintResult

KtoF:    # °F = (K - 273.15) × 9/5 + 32
    jal GetInput
    l.s $f1, f273_15
    l.s $f2, f9_5
    l.s $f3, f32_0
    sub.s $f0, $f0, $f1
    mul.s $f0, $f0, $f2
    add.s $f0, $f0, $f3
    j PrintResult

CtoK:    # K = °C + 273.15
    jal GetInput
    l.s $f1, f273_15
    add.s $f0, $f0, $f1
    j PrintResult

FtoK:    # K = (°F - 32) × 5/9 + 273.15
    jal GetInput
    l.s $f1, f32_0
    l.s $f2, f5_9
    l.s $f3, f273_15
    sub.s $f0, $f0, $f1
    mul.s $f0, $f0, $f2
    add.s $f0, $f0, $f3
    j PrintResult

# Currency Menu Section
CurrencyMenu:
    li $v0, 4
    la $a0, currMenu
    syscall
    
    li $v0, 4
    la $a0, prompt
    syscall
    li $v0, 5
    syscall
    move $t1, $v0

    blt $t1, 1, InvalidCurrChoice
    bgt $t1, 6, InvalidCurrChoice

    beq $t1, 1, USDtoEUR
    beq $t1, 2, EURtoUSD
    beq $t1, 3, USDtoGBP
    beq $t1, 4, EURtoGBP
    beq $t1, 5, GBPtoUSD
    beq $t1, 6, main

InvalidCurrChoice:
    li $v0, 4
    la $a0, invalidMsg
    syscall
    j CurrencyMenu

# Currency Conversions
USDtoEUR:
    jal GetRate
    jal GetInput
    mul.s $f0, $f0, $f1
    j PrintResult

EURtoUSD:
    jal GetRate
    jal GetInput
    div.s $f0, $f0, $f1
    j PrintResult

USDtoGBP:
    jal GetRate
    jal GetInput
    mul.s $f0, $f0, $f1
    j PrintResult

EURtoGBP:
    jal GetRate
    jal GetInput
    mul.s $f0, $f0, $f1
    j PrintResult

GBPtoUSD:
    jal GetRate
    jal GetInput
    mul.s $f0, $f0, $f1
    j PrintResult

# Length Menu Section
LengthMenu:
    li $v0, 4
    la $a0, lengthMenu
    syscall
    
    li $v0, 4
    la $a0, prompt
    syscall
    li $v0, 5
    syscall
    move $t1, $v0

    blt $t1, 1, InvalidLengthChoice
    bgt $t1, 6, InvalidLengthChoice

    beq $t1, 1, MtoF
    beq $t1, 2, FtoM
    beq $t1, 3, MtoY
    beq $t1, 4, YtoM
    beq $t1, 5, MtoI
    beq $t1, 6, main

InvalidLengthChoice:
    li $v0, 4
    la $a0, invalidMsg
    syscall
    j LengthMenu

# Length Conversions
MtoF:    # Meters to Feet
    jal GetInput
    l.s $f1, f3_28084
    mul.s $f0, $f0, $f1
    j PrintResult

FtoM:    # Feet to Meters
    jal GetInput
    l.s $f1, f3_28084
    div.s $f0, $f0, $f1
    j PrintResult

MtoY:    # Meters to Yards
    jal GetInput
    l.s $f1, f1_09361
    mul.s $f0, $f0, $f1
    j PrintResult

YtoM:    # Yards to Meters
    jal GetInput
    l.s $f1, f1_09361
    div.s $f0, $f0, $f1
    j PrintResult

MtoI:    # Meters to Inches
    jal GetInput
    l.s $f1, f39_3701
    mul.s $f0, $f0, $f1
    j PrintResult

# Volume Menu Section
VolumeMenu:
    li $v0, 4
    la $a0, volumeMenu
    syscall
    
    li $v0, 4
    la $a0, prompt
    syscall
    li $v0, 5
    syscall
    move $t1, $v0

    blt $t1, 1, InvalidVolumeChoice
    bgt $t1, 6, InvalidVolumeChoice

    beq $t1, 1, LtoG
    beq $t1, 2, GtoL
    beq $t1, 3, MLtoOZ
    beq $t1, 4, OZtoML
    beq $t1, 5, LtoCM
    beq $t1, 6, main

InvalidVolumeChoice:
    li $v0, 4
    la $a0, invalidMsg
    syscall
    j VolumeMenu

# Volume Conversions
LtoG:    # Liters to Gallons
    jal GetInput
    l.s $f1, f0_264172
    mul.s $f0, $f0, $f1
    j PrintResult

GtoL:    # Gallons to Liters
    jal GetInput
    l.s $f1, f0_264172
    div.s $f0, $f0, $f1
    j PrintResult

MLtoOZ:  # Milliliters to Ounces
    jal GetInput
    l.s $f1, f0_033814
    mul.s $f0, $f0, $f1
    j PrintResult

OZtoML:  # Ounces to Milliliters
    jal GetInput
    l.s $f1, f0_033814
    div.s $f0, $f0, $f1
    j PrintResult

LtoCM:   # Liters to Cubic Meters
    jal GetInput
    l.s $f1, f1000_0    # Changed from li.s to using predefined constant
    div.s $f0, $f0, $f1
    j PrintResult

# Weight Menu Section
WeightMenu:
    li $v0, 4
    la $a0, weightMenu
    syscall
    
    li $v0, 4
    la $a0, prompt
    syscall
    li $v0, 5
    syscall
    move $t1, $v0

    blt $t1, 1, InvalidWeightChoice
    bgt $t1, 6, InvalidWeightChoice

    beq $t1, 1, KGtoLB
    beq $t1, 2, LBtoKG
    beq $t1, 3, GtoOZ
    beq $t1, 4, OZtoG
    beq $t1, 5, KGtoST
    beq $t1, 6, main

InvalidWeightChoice:
    li $v0, 4
    la $a0, invalidMsg
    syscall
    j WeightMenu

# Weight Conversions
KGtoLB:  # Kilograms to Pounds
    jal GetInput
    l.s $f1, f2_20462
    mul.s $f0, $f0, $f1
    j PrintResult

LBtoKG:  # Pounds to Kilograms
    jal GetInput
    l.s $f1, f2_20462
    div.s $f0, $f0, $f1
    j PrintResult

GtoOZ:   # Grams to Ounces
    jal GetInput
    l.s $f1, f0_033814
    mul.s $f0, $f0, $f1
    j PrintResult

OZtoG:   # Ounces to Grams
    jal GetInput
    l.s $f1, f0_033814
    div.s $f0, $f0, $f1
    j PrintResult

KGtoST:  # Kilograms to Stones
    jal GetInput
    l.s $f1, f0_157473
    mul.s $f0, $f0, $f1
    j PrintResult

# Speed Menu Section
SpeedMenu:
    li $v0, 4
    la $a0, speedMenu
    syscall
    
    li $v0, 4
    la $a0, prompt
    syscall
    li $v0, 5
    syscall
    move $t1, $v0

    blt $t1, 1, InvalidSpeedChoice
    bgt $t1, 6, InvalidSpeedChoice

    beq $t1, 1, MStoKH
    beq $t1, 2, KHtoMS
    beq $t1, 3, MPHtoKH
    beq $t1, 4, KHtoMPH
    beq $t1, 5, FPStoMS
    beq $t1, 6, main

InvalidSpeedChoice:
    li $v0, 4
    la $a0, invalidMsg
    syscall
    j SpeedMenu

# Speed Conversions
MStoKH:  # Meters/Second to Kilometers/Hour
    jal GetInput
    l.s $f1, f3_6
    mul.s $f0, $f0, $f1
    j PrintResult

KHtoMS:  # Kilometers/Hour to Meters/Second
    jal GetInput
    l.s $f1, f3_6
    div.s $f0, $f0, $f1
    j PrintResult

MPHtoKH: # Miles/Hour to Kilometers/Hour
    jal GetInput
    l.s $f1, f1_60934
    mul.s $f0, $f0, $f1
    j PrintResult

KHtoMPH: # Kilometers/Hour to Miles/Hour
    jal GetInput
    l.s $f1, f1_60934
    div.s $f0, $f0, $f1
    j PrintResult

FPStoMS: # Feet/Second to Meters/Second
    jal GetInput
    l.s $f1, f0_3048
    mul.s $f0, $f0, $f1
    j PrintResult

# Energy Menu Section
EnergyMenu:
    li $v0, 4
    la $a0, energyMenu
    syscall
    
    li $v0, 4
    la $a0, prompt
    syscall
    li $v0, 5
    syscall
    move $t1, $v0

    blt $t1, 1, InvalidEnergyChoice
    bgt $t1, 6, InvalidEnergyChoice

    beq $t1, 1, JtoCAL
    beq $t1, 2, CALtoJ
    beq $t1, 3, KWHtoJ
    beq $t1, 4, JtoKWH
    beq $t1, 5, CALtoKJ
    beq $t1, 6, main

InvalidEnergyChoice:
    li $v0, 4
    la $a0, invalidMsg
    syscall
    j EnergyMenu

# Energy Conversions
JtoCAL:  # Joules to Calories
    jal GetInput
    l.s $f1, f4_184
    div.s $f0, $f0, $f1
    j PrintResult

CALtoJ:  # Calories to Joules
    jal GetInput
    l.s $f1, f4_184
    mul.s $f0, $f0, $f1
    j PrintResult

KWHtoJ:  # Kilowatt-hours to Joules
    jal GetInput
    l.s $f1, f3600000
    mul.s $f0, $f0, $f1
    j PrintResult

JtoKWH:  # Joules to Kilowatt-hours
    jal GetInput
    l.s $f1, f3600000
    div.s $f0, $f0, $f1
    j PrintResult

CALtoKJ: # Calories to Kilojoules
    jal GetInput
    l.s $f1, f4_184
    mul.s $f0, $f0, $f1
    l.s $f2, f1000_0    # Changed from li.s to using predefined constant
    div.s $f0, $f0, $f2
    j PrintResult

# Pressure Menu Section
PressureMenu:
    li $v0, 4
    la $a0, pressureMenu
    syscall
    
    li $v0, 4
    la $a0, prompt
    syscall
    li $v0, 5
    syscall
    move $t1, $v0

    blt $t1, 1, InvalidPressureChoice
    bgt $t1, 6, InvalidPressureChoice

    beq $t1, 1, PaToAtm
    beq $t1, 2, AtmToPa
    beq $t1, 3, PaToBar
    beq $t1, 4, BarToPa
    beq $t1, 5, TorrToAtm
    beq $t1, 6, main

InvalidPressureChoice:
    li $v0, 4
    la $a0, invalidMsg
    syscall
    j PressureMenu

# Pressure Conversions
PaToAtm:  # Pascals to Atmospheres
    jal GetInput
    l.s $f1, f101325
    div.s $f0, $f0, $f1
    j PrintResult

AtmToPa:  # Atmospheres to Pascals
    jal GetInput
    l.s $f1, f101325
    mul.s $f0, $f0, $f1
    j PrintResult

PaToBar:  # Pascals to Bar
    jal GetInput
    l.s $f1, f100000
    div.s $f0, $f0, $f1
    j PrintResult

BarToPa:  # Bar to Pascals
    jal GetInput
    l.s $f1, f100000
    mul.s $f0, $f0, $f1
    j PrintResult

TorrToAtm: # Torr to Atmospheres
    jal GetInput
    l.s $f1, f760
    div.s $f0, $f0, $f1
    j PrintResult

# Common Functions
GetInput:
    li $v0, 4
    la $a0, enterValue
    syscall
    li $v0, 6           # Read float
    syscall
    mov.s $f0, $f0      # Move input to $f0
    jr $ra

GetRate:
    li $v0, 4
    la $a0, enterRate
    syscall
    li $v0, 6           # Read float
    syscall
    mov.s $f1, $f0      # Move rate to $f1
    jr $ra

PrintResult:
    li $v0, 4
    la $a0, outputValue
    syscall
    li $v0, 2           # Print float
    mov.s $f12, $f0
    syscall

    # Ask about another conversion
    li $v0, 4
    la $a0, repeatMsg
    syscall
    li $v0, 5
    syscall
    beqz $v0, Exit
    j main

Exit:
    li $v0, 10
    syscall
