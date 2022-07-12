with campaign_report as (
    
    select *
    from {{ var('campaign_report') }}
), 

campaign as (

    select *
    from {{ var('campaign_history') }}
    where is_most_recent_record = True
), 

organization as (

    select * 
    from {{ var('organization') }}
), 

joined as (

    select 
        campaign_report.date_day,
        organization.organization_id,
        organization.organization_name,
        organization.currency,
        sum(campaign_report.taps) as taps,
        sum(campaign_report.new_downloads) as new_downloads,
        sum(campaign_report.redownloads) as redownloads,
        sum(campaign_report.new_downloads + campaign_report.redownloads) as total_downloads,
        sum(campaign_report.impressions) as impressions,
        sum(campaign_report.spend) as spend
    from campaign_report
    join campaign 
        on campaign_report.campaign_id = campaign.campaign_id
    join organization 
        on campaign.organization_id = organization.organization_id
    {{ dbt_utils.group_by(4) }}
)

select * 
from joined