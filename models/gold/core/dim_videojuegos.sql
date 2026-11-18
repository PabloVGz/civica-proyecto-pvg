with videojuegos as (

    select * from {{ ref('slv_videojuegos__videojuegos') }}

),

generos as (

    select * from {{ ref('slv_videojuegos__generos') }}

),

macrogeneros as (

    select * from {{ ref('slv_videojuegos__macrogeneros') }}

)

select
    v.game_id,
    v.game_name,
    g.genre_name,
    mg.macrogenre_name
from videojuegos v
left join generos g
    on v.genre_id = g.genre_id
left join macrogeneros mg
    on g.macrogenre_id = mg.macrogenre_id