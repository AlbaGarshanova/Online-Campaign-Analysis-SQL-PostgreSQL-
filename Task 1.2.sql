with facebook_google as
(select ad_date, 'Facebook Ads' as media_source, pf.campaign_name, pfa.adset_name, spend, value
from public.facebook_ads_basic_daily as pfabd
left join public.facebook_adset as pfa
on pfa.adset_id = pfabd.adset_id
left join public.facebook_campaign  as pf
on pf.campaign_id = pfabd.campaign_id
union all
select 
ad_date, 'Google Ads' as media_source, campaign_name, adset_name, spend, value
from public.google_ads_basic_daily)
select ad_date,
case
	when sum(spend) >0
	then round(sum(value)::numeric / sum (spend), 2)
	else 0
end as total_romi
from facebook_google
group by 1
order by total_romi desc 
limit 5
