with ad_group_report as (
    select *
    from {{ var('ad_group_report') }}
), ad_group as (
    select * 
    from {{ ref('int_apple_search_ads__most_recent_ad_group') }}
), campaign as (
    select *
    from {{ ref('int_apple_search_ads__most_recent_campaign') }}
), organization as (
    select * 
    from {{ var('organization') }}
), joined as (
    select 
        organization.organization_id,
        organization.organization_name,
        campaign.campaign_id, 
        campaign.campaign_name, 
        ad_group.ad_group_id,
        ad_group.ad_group_name,
        ad_group_report.date_day,
        ad_group_report.taps,
        ad_group_report.new_downloads,
        ad_group_report.redownloads,
        ad_group_report.impressions,
        ad_group_report.local_spend_amount as spend,
        ad_group_report.local_spend_currency as currency
    from ad_group_report
    join ad_group on ad_group_report.ad_group_id = ad_group.ad_group_id
    join campaign on ad_group.campaign_id = campaign.campaign_id
    join organization on ad_group.organization_id = organization.organization_id
)

select * from joined
