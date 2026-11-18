with ediciones as (

    select * from {{ ref('slv_videojuegos__ediciones') }}

),

developers as (

    select * from {{ ref('slv_videojuegos__developers') }}

),

ratings as (

    select * from {{ ref('slv_videojuegos__ratings') }}

)

select
    e.edicion_id,
    e.game_id,
    e.platform_id,
    e.publisher_id,
    e.developer_id,
    d.developer_name,
    e.rating_id,
    r.rating_code,
    r.rating_description,
    e.release_year,
    e.critic_score,
    e.critic_count,
    e.user_score,
    e.user_count
from ediciones e
left join developers d
    on e.developer_id = d.developer_id
left join ratings r
    on e.rating_id = r.rating_id