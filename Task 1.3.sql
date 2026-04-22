with facebook_google as
(select ad_date, pf.campaign_name, pfa.adset_name, spend, value
from public.facebook_ads_basic_daily as pfabd
left join public.facebook_adset as pfa
on pfa.adset_id = pfabd.adset_id
left join public.facebook_campaign  as pf
on pf.campaign_id = pfabd.campaign_id
union all
select 
ad_date, campaign_name, adset_name, spend, value
from public.google_ads_basic_daily)
select date_trunc('week', ad_date)::date as week_start, campaign_name,
sum(value)::numeric as total_value
from facebook_google
where campaign_name is not null and value > 0
group by 1, 2
order by total_value desc
limit 1