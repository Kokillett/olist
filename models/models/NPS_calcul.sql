select 
promoters_1
,passive
,detractors
from {{ ref('CentralizedData') }}
