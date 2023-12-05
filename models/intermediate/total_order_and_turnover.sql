SELECT 
sum(total_number_orders) as total_number_orders
,sum(turnover) as turnover
,date_1, time_time
from {{ ref('CentralizedData') }}
GROUP BY date_1,time_time