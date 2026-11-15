with videojuegos as (

    select * from {{ ref('slv_videojuegos__videojuegos') }}

),

generos as (

    select * from {{ ref('slv_videojuegos__generos') }}

),

macrogeneros as (

    select * from {{ ref('slv_videojuegos__macrogeneros') }}

),

developers as (

    select * from {{ ref('slv_videojuegos__developers') }}

),

ratings as (

    select * from {{ ref('slv_videojuegos__ratings') }}

)

select
    v.game_id,
    v.game_name,
    g.genre_name,
    mg.macrogenre_name,
    d.developer_name,
    r.rating_code
from videojuegos v
left join generos g
    on v.genre_id = g.genre_id
left join macrogeneros mg
    on g.macrogenre_id = mg.macrogenre_id
left join developers d
    on v.developer_id = d.developer_id
left join ratings r
    on v.rating_id = r.rating_id