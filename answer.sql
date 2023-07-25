select * from data_film;

select year(release_date) as yearr 
from data_film
order by yearr;

-- 1. Rata rata dan jumlah budget, pendapatan mereka
select company,
avg(revenue) as avg_rev, sum(budget) as total_budget
from data_film
where company in ("Marvel Studios", "DC Comics")
group by company;


-- 2. Total film yang mereka produksi dari tahun 2000
select company, count(title) as total_film_above_2000
from data_film
where company in ("Marvel Studios", "DC Comics") and year(release_date) >= 2000
group by company;

-- 3. Film yang memiliki pendapatan terbanyak dari masing2 company
with comp as
(
select distinct company
from data_film
where company in ("Marvel Studios", "DC Comics")
),
max_film_marvel as
(
select company, title, max(revenue) as max_rev
from data_film
where company = "Marvel Studios"
group by company, title
order by max_rev desc
limit 1
),
max_film_dc as
(
select company, title, max(revenue) as max_rev
from data_film
where company = "DC Comics"
group by company, title
order by max_rev desc
limit 1
)

select comp.company,
max_film_marvel.title, max_film_marvel.max_rev,
max_film_dc.title, max_film_dc.max_rev
from comp
left join max_film_marvel
on comp.company = max_film_marvel.company
left join max_film_dc
on comp.company = max_film_dc.company;

-- 4. Film yang memiliki popularity terbanyak dari masing2 company
with comp as
(
select distinct company
from data_film
where company in ("Marvel Studios", "DC Comics")
),
marvel as
(
select company, title, max(popularity) as max_pol
from data_film
where company = "Marvel Studios"
group by company, title
order by max_pol desc
limit 1
),
dc as
(
select company, title, max(popularity) as max_pol
from data_film
where company = "DC Comics"
group by company, title
order by max_pol desc
limit 1
)

select comp.company,
marvel.title, marvel.max_pol,
dc.title, dc.max_pol
from comp
left join marvel
on comp.company = marvel.company
left join dc
on comp.company = dc.company;

-- 5. Apakah film yang memiliki popularity tertinggi dari masing-masing company berbanding lurus dengan vote averagenya
with comp as
(
select distinct company
from data_film
where company in ("Marvel Studios", "DC Comics")
),
marvel_pol as
(
select company, title, max(popularity) as max_pol
from data_film
where company = "Marvel Studios"
group by company, title
order by max_pol desc
limit 1
),
marvel_vote as 
(
select company, title, max(vote_average) as max_vote
from data_film
where company = "Marvel Studios"
group by company, title
order by max_vote desc
limit 1
)
,
dc_pol as
(
select company, title, max(popularity) as max_pol
from data_film
where company = "dc comics"
group by company, title
order by max_pol desc
limit 1
),
dc_vote as 
(
select company, title, max(vote_average) as max_vote
from data_film
where company = "dc comics"
group by company, title
order by max_vote desc
limit 1
)

select comp.company,
marvel_pol.title, marvel_pol.max_pol,
marvel_vote.title, marvel_vote.max_vote,
dc_pol.title, dc_pol.max_pol,
dc_vote.title, dc_vote.max_vote
from comp
left join marvel_pol
on comp.company = marvel_pol.company
left join dc_pol
on comp.company = dc_pol.company
left join marvel_vote
on comp.company = marvel_vote.company
left join dc_vote
on comp.company = dc_vote.company;