with facebook_google as
(select ad_date, 'Facebook Ads' as media_source, pf.campaign_name, pfa.adset_name, spend
from public.facebook_ads_basic_daily as pfabd
left join public.facebook_adset as pfa
on pfa.adset_id = pfabd.adset_id
left join public.facebook_campaign  as pf
on pf.campaign_id = pfabd.campaign_id
union all
select 
ad_date, 'Google Ads' as media_source, campaign_name, adset_name, spend
from public.google_ads_basic_daily)
select ad_date, media_source,
avg (spend)::numeric as avg_spend,
max(spend)::numeric as max_spend,
min(spend)::numeric as min_spend
from facebook_google
where campaign_name is not null
group by 1, 2
order by 1, 2



