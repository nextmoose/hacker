#!/bin/sh

tee | fold --width 1 | while read X
do
    printf "%d\n" "\"${X}\""
done | while read X
do
    case ${X} in
        0)
            echo Nul
        ;;
        1)
            echo Soh
        ;;
        2)
            echo Stx
        ;;
        3)
            echo Etx
        ;;
        4)
            echo Eot
        ;;
        5)
            echo Enq
        ;;
        6)
            echo Ack
        ;;
        7)
            echo Bel
        ;;
        8)
            echo Bs
        ;;
        9)
            echo Ht
        ;;
        10)
            echo Lf
        ;;
        11)
            echo Vt
        ;;
        12)
            echo Ff
        ;;
        13)
            echo Cr
        ;;
        14)
            echo So
        ;;
        15)
            echo Si
        ;;
        16)
            echo Dle
        ;;
        17)
            echo Dc1
        ;;
        18)
            echo Dc2
        ;;
        19)
            echo Dc3
        ;;
        20)
            echo Dc4
        ;;
        21)
            echo Nak
        ;;
        22)
            echo Syn
        ;;
        23)
            echo Etb
        ;;
        24)
            echo Can
        ;;
        25)
            echo Em
        ;;
        26)
            echo Sub
        ;;
        27)
            echo Esc
        ;;
        28)
            echo Fs
        ;;
        29)
            echo Gs
        ;;
        30)
            echo Rs
        ;;
        31)
            echo Us
        ;;
        32)
            echo Space
        ;;
        33)
            echo ExclamationPoint
        ;;
        34)
            echo DoubleQuote
        ;;
        35)
            echo Hash
        ;;
        36)
            echo Dollar
        ;;
        37)
            echo Percent
        ;;
        38)
            echo Ampersand
        ;;
        39)
            echo SingleQuote
        ;;
        40)
            echo OpenRoundBracket
        ;;
        41)
            echo CloseRoundBracket
        ;;
        42)
            echo Asterisk
        ;;
        43)
            echo Plus
        ;;
        44)
            echo Comma
        ;;
        45)
            echo Hyphen
        ;;
        46)
            echo Period
        ;;
        47)
            echo ForwardSlash
        ;;
        48)
            echo Zero
        ;;
        49)
            echo One
        ;;
        50)
            echo Two
        ;;
        51)
            echo Three
        ;;
        52)
            echo Four
        ;;
        53)
            echo Five
        ;;
        54)
            echo Six
        ;;
        55)
            echo Seven
        ;;
        56)
            echo Eight
        ;;
        57)
            echo Nine
        ;;
        58)
            echo Colon
        ;;
        59)
            echo Semicolon
        ;;
        60)
            echo LessThan
        ;;
        61)
            echo Equals
        ;;
        62)
            echo GreaterThan
        ;;
        63)
            echo QuestionMark
        ;;
        64)
            echo At
        ;;
        65)
            echo ALFA
        ;;
        66)
            echo BRAVO
        ;;
        67)
            echo CHARLIE
        ;;
        68)
            echo DELTA
        ;;
        69)
            echo ECHO
        ;;
        70)
            echo FOXTROT
        ;;
        71)
            echo GOLF
        ;;
        72)
            echo HOTEL
        ;;
        73)
            echo INDIA
        ;;
        74)
            echo JULIET
        ;;
        75)
            echo KILO
        ;;
        76)
            echo LIMA
        ;;
        77)
            echo MIKE
        ;;
        78)
            echo NOVEMBER
        ;;
        79)
            echo OSCAR
        ;;
        80)
            echo PAPA
        ;;
        81)
            echo QUEBEC
        ;;
        82)
            echo ROMEO
        ;;
        83)
            echo SIERRA
        ;;
        84)
            echo TANGO
        ;;
        85)
            echo UNIFORM
        ;;
        86)
            echo VICTOR
        ;;
        87)
            echo WHISKEY
        ;;
        88)
            echo XRAY
        ;;
        89)
            echo YANKEE
        ;;
        90)
            echo ZULU
        ;;
        91)
            echo OpenSquareBracket
        ;;
        92)
            echo BackwardSlash
        ;;
        93)
            echo CloseSquareBracket
        ;;
        94)
            echo Caret
        ;;
        95)
            echo Underscore
        ;;
        96)
            echo Grave
        ;;
        97)
            echo alfa
        ;;
        98)
            echo brava
        ;;
        99)
            echo charlie
        ;;
        100)
            echo delta
        ;;
        101)
            echo echo
        ;;
        102)
            echo foxtrot
        ;;
        103)
            echo golf
        ;;
        104)
            echo hotel
        ;;
        105)
            echo india
        ;;
        106)
            echo juliet
        ;;
        107)
            echo kilo
        ;;
        108)
            echo lima
        ;;
        109)
            echo mike
        ;;
        110)
            echo november
        ;;
        111)
            echo oscar
        ;;
        112)
            echo papa
        ;;
        113)
            echo quebec
        ;;
        114)
            echo romeo
        ;;
        115)
            echo sierra
        ;;
        116)
            echo tango
        ;;
        117)
            echo uniform
        ;;
        118)
            echo victor
        ;;
        119)
            echo whiskey
        ;;
        120)
            echo xray
        ;;
        121)
            echo yankee
        ;;
        122)
            echo zulu
        ;;
        123)
            echo OpenCurlyBracket
        ;;
        124)
            echo Pipe
        ;;
        125)
            echo CloseCurlyBracket
        ;;
        125)
            echo Tilde
        ;;
        126)
            echo 
        ;;
        *)
            echo Code[${X}]
        ;;
        A)
            Alprintf '%03o' "$1"
    esac
done