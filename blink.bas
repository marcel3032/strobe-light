REM EEPROM:
REM 0: pocet celych 15 minutoviek behu
REM 1: pocet zapnuti
REM 2: maximalna teplota + 100C

; pullup on
pullup %11010

read 0,b10
read 1,b11
read 2,b12
sertxd("15 mins = ",#b10," zapnutia = ",#b11," max tmp = ",#b12,13,10)

REM---------------------------
REM zaznamenanie zapnutia
read 1,b11
inc b11
write 1,b11
REM---------------------------

START:
readadc 2,b15
; sertxd("adc = ",#b15,13,10)

high 1
pause 30 ; prvy blik
low 1
pause 20 ; pauza
high 1
pause 30 ; druhy blik
low 1
pause 20 ; pauza
high 1
pause 30 ; treti blik
low 1
pause 1075 ; zvysok

REM---------------------------
REM meranie teploty 
b22 = b2 ; stara teplota
readinternaltemp IT_5V0,-44,b2 ; odmeriame novu teplotu
; sertxd("temp = ",#b22, " temp2 = ", #b2,13,10)

if b22>b2 then let b22 = b22-b2 else let b22 = b2-b22 endif ; zistime rozdiel
if b22 > 20 then goto SKIP ; ak je rozdiel teplot vacsi ako 20, tak je nieco zle

; inak teplotu ulozime (ak je vacsia ako doterajsie maximum)
; sertxd("small diff",13,10)
read 2,b12
if b2>b12 then write 2,b2 endif

SKIP:

REM---------------------------
REM ulozenie 15 minutovky
if time<1500 then goto start

time = time-1500 ; reset casu
read 0,b10
inc b10
write 0,b10
REM---------------------------

goto start