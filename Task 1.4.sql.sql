with facebook_google as 
(select 
	ad_date, pf.campaign_name, pfa.adset_name, spend, value, reach
from public.facebook_ads_basic_daily as pfabd
left join public.facebook_adset as pfa
	on pfa.adset_id = pfabd.adset_id
left join public.facebook_campaign  as pf
	on pf.campaign_id = pfabd.campaign_id
union all
select 
	ad_date, campaign_name, adset_name, spend, value, reach
from public.google_ads_basic_daily),
	total_reach as 
(select 
	campaign_name, 
	date_trunc('month', ad_date)::date as ad_month,
	sum(reach)::numeric as total_month_reach
from facebook_google
where campaign_name is not null
group by campaign_name, ad_month
having sum(reach) > 0),
lag_reach as
(select 
	ad_month, campaign_name, total_month_reach, 
	lag (total_month_reach, 1) over (partition by campaign_name order by ad_month) as previous_reach
from total_reach)
select
	ad_month, campaign_name, total_month_reach, previous_reach,
	abs(total_month_reach - previous_reach) as reach_change
from lag_reach
where previous_reach is not null
order by reach_change desc
limit 1

