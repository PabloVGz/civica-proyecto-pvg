with ventas as (

    select * from {{ ref('slv_videojuegos__ventas_regionales') }}

),

ediciones_enriched as (

    select * from {{ ref('gold_ediciones__enriched') }}

)

select
    v.sale_id,
    v.edicion_id,
    e.game_id,
    e.platform_id,
    e.publisher_id,
    v.region_id,
    v.source_code,
    e.release_year,
    v.sales_millions,
    e.critic_score,
    e.critic_count,
    e.user_score,
    e.user_count
from ventas v
left join ediciones_enriched e
    on v.edicion_id = e.edicion_id