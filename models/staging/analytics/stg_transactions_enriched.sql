{{ config(materialized='incremental', incremental_strategy='append', on_schema_change='sync_all_columns') }}

with token_transfers_agg as (
    select 
    transaction_hash, 
    count(*) as token_transfers_count
    from {{ ref('stg_token_transfers') }}
    group by transaction_hash    
),
transactions_enriched as (
select 
t.hash,
t.block_number,
t.date,
t.from_address,
t.to_address,
t.value,
t.receipt_contract_address,
t.input,
tt.token_transfers_count,
case when t.receipt_contract_address != '' then 'contract_creation' 
     when tt.transaction_hash is not null then 'token_transfer' 
     when t.input = '0x' and t.value > 0 then 'plain_ether_transfer' 
else 'other'
end as transaction_category,
1 as newfield

from {{ ref('stg_transactions') }} t

left join ({{ ref('token_transfers_agg') }}) tt 
on t.hash = tt.transaction_hash     


{% if is_incremental() %}

where t.date >= (select max(date) from {{ this }})

{% endif %}

)

select 
* 
from transactions_enriched