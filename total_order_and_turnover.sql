SELECT 
sum(total_number_orders) as total_number_orders
,sum(turnover) as turnover
,date_1
from {{ ref('CentralizedData') }}
GROUP BY date_1