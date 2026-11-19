with ediciones as (

    select * from {{ ref('slv_videojuegos__ediciones') }}

),

videojuegos as (

    select * from {{ ref('slv_videojuegos__videojuegos') }}

),

ratings as (

    select * from {{ ref('slv_videojuegos__ratings') }}

),

calculos_edicion as (

    select
        e.edicion_id,
        v.game_name,
        e.release_year,
        case
            when e.release_year is not null
                then concat(floor(e.release_year / 10) * 10, 's')
            else 'Unknown'
        end as decada_lanzamiento,
        coalesce(r.rating_code, 'Unrated') as rating_code,
        coalesce(r.rating_description, 'Unrated / Not Specified') as rating_description,
        count(distinct e.platform_id) over (partition by e.game_id) as total_plataformas,
        e.critic_score,
        e.critic_count,
        e.user_score,
        e.user_count
    from ediciones e
    left join videojuegos v
        on e.game_id = v.game_id
    left join ratings r
        on e.rating_id = r.rating_id

)

select
    edicion_id,
    game_name,
    release_year,
    decada_lanzamiento,
    rating_code,
    rating_description,
    (total_plataformas > 1) as es_multiplataforma,
    total_plataformas,
    critic_score,
    critic_count,
    user_score,
    user_count
from calculos_edicion