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