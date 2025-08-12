# dailybudget

Requirements:

1. Overview show actual limit for today
2. By pressing button the pop-up widow appear to add spending
3. In special cases button "update limits" show up

Limit:
1. limit = min(maxLimit, (budget/days_to_payday))
2. add spending -> limit = limit - spending and budget = budget - spending
3. when limit =< 0:
    - show update limits button
4. budget always >=0





Is __actual_date__ is 12.06., __payday__ is 10. everymonth:
__budget__ = 10000
__max_limit__ = 100

event:
__updateLimit()__

check:
__days_to_payday__ == 28
__limit__ = min(100, 10000/28) = 100
__actual_limit__ = 100

Event:
add __sepnding__ = 10

check:
__actual_limit__ = 90
__budget__ = 9990

Event:
add __spending__ = 100

chcek:
pop-up __limit_below_zero()__
    A. __borrow__ = 10
    or
    B. __updateLimit()__


A.
check:
__actual_limit__ == 0
__borrow__ == 10
__budget__ == 9890

event:
change __actual_date__ = 13.06.

check:
__actual_limit__ == 90
__borrow__ == 0

event:
change __actual_date__ = 14.06.

check:
__actual_limit__ == 190
__limit__ == 100

B.
check:
__limit__ = min(100, 9890/28) = 100
__actual_limit__ == 100
__borrow__ == 0
__budget__ == 9890


If __spending__ is less than 0 (it is paid)

pop-up __updateOrAdd__

A: __updateLimit()__
B: __addSpending()__




## FEATURES:

### Description:

Start app and all values are as before las close.

Write spending or STT.

Snyc with cloud - Firebase.

All texts should be depends from language select in settings

### List:
1. SharedPreferences
2. STT
3. Firebase
4. Many laguages




UI:
1. Main overview page:
    1.1. __actualLimitState__ indicator
    1.2. Input field:
        1.2.1. Input text
        1.2.2. Input STT
        1.2.3. Send __output_event_0__ with __spending__ vlaue
2. Popup after __input_event_0__:
    2.1. send __output_vlaue_1__
    2.2. send __output_vlaue_2__
3. Popup after __input_event_1__:
    3.1. send __output_vlaue_1__
    3.2. send __output_vlaue_3__


BLOC:
1. set state __actualLimitState__
2. add __spending__
3. read parameters:
    3.1.

REPOSITORY:
1. Parameters
2. Actual data




BACKLOG:

1. Documentation
2. ~~STT~~
3. ~~Localization~~
4. Widget Android
5. Widget iOS
6. Loging events
7. ~~Resizable overview~~


