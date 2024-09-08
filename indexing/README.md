# 'explain analyze' with 'select'

metadata:
  - total row:   100482 `SELECT COUNT(*) FROM land_registry_price_paid_uk;`

command to create index

```
CREATE INDEX IF NOT EXISTS land_registry_price_paid_uk_transaction on land_registry_price_paid_uk(transaction);
```

## first attemp
(placed in top of row)

query

```
explain analyze select * from land_registry_price_paid_uk where transaction = '1eae3df6-b9f2-9eb1-e063-4704a8c09d02';
```


> Without index

result

```bash
QUERY PLAN                                                        
----------------------------------------------
 Seq Scan on land_registry_price_paid_uk  (cost=0.00..2970.03 rows=1 width=101) (actual time=0.018..9.297 rows=1 loops=1)
   Filter: (transaction = '1eae3df6-b9f2-9eb1-e063-4704a8c09d02'::uuid)
   Rows Removed by Filter: 100481
 Planning time: 0.079 ms
 Execution time: 9.321 ms
(5 rows)

```

> with index

result
```bash
QUERY PLAN                                                                               
------------------------------------------------
Index Scan using land_registry_price_paid_uk_transaction on land_registry_price_paid_uk  (cost=0.42..8.44 rows=1 width=101) (actual time=0.070..0.071 rows=1 loops=1)
   Index Cond: (transaction = '1eae3df6-b9f2-9eb1-e063-4704a8c09d02'::uuid)
 Planning time: 0.403 ms
 Execution time: 0.103 ms
(4 rows)

```

conclusion

 -- | no index | with index 
---|---|---
method | sequence | index
planning time (ms) | 0.079 | 0.403
execution time (ms) | 9.321 | 0.103
total time (ms) | 9.400 | 0.506 

time taken for 'with index' is less than 'no index' with delta 8.894. so 'with index' is more effective

## second attemp
(placed bottom of row)

query
```bash
explain analyze select * from land_registry_price_paid_uk where transaction = 'ffa361db-9970-8a03-e053-4804a8c01f61';
```

> without index

result
```bash
QUERY PLAN                                                         
-----------------------------------------------
 Seq Scan on land_registry_price_paid_uk  (cost=0.00..2970.03 rows=1 width=101) (actual time=1.402..12.120 rows=1 loops=1)
   Filter: (transaction = 'ffa361db-9970-8a03-e053-4804a8c01f61'::uuid)
   Rows Removed by Filter: 100481
 Planning time: 0.101 ms
 Execution time: 12.154 ms
(5 rows)
```

> with index
result
```bash
QUERY PLAN                                                                               
-----------------------------------------------
 Index Scan using land_registry_price_paid_uk_transaction on land_registry_price_paid_uk  (cost=0.42..8.44 rows=1 width=101) (actual time=0.011..0.012 rows=1 loops=1)
   Index Cond: (transaction = 'ffa361db-9970-8a03-e053-4804a8c01f61'::uuid)
 Planning time: 0.120 ms
 Execution time: 0.023 ms
(4 rows)
```

 -- | no index | with index 
---|---|---
method | sequence | index
planning time (ms) | 0.101 | 0.120
execution time (ms) | 12.154 | 0.023
total time (ms) | 12.255 | 0.143

time taken for 'with index' is less than 'no index' with delta 12.112. so 'with index' is more effective
