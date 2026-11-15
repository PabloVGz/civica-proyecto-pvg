with ediciones as (

    select * from {{ ref('slv_videojuegos__ediciones') }}

),

critica as (

    select * from {{ ref('slv_videojuegos__puntuaciones_critica') }}

),

usuarios as (

    select * from {{ ref('slv_videojuegos__puntuaciones_usuarios') }}

)

select
    e.edicion_id,
    e.game_id,
    e.platform_id,
    e.publisher_id,
    e.release_year,
    c.critic_score,
    c.critic_count,
    u.user_score,
    u.user_count
from ediciones e
left join critica c
    on e.edicion_id = c.edicion_id
left join usuarios u
    on e.edicion_id = u.edicion_id