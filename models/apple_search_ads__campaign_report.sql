{{ config(enabled=var('ad_reporting__apple_search_ads_enabled', True)) }}

with report as (
    
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
        report.source_relation,
        report.date_day,
        campaign.organization_id,
        organization.organization_name,
        report.campaign_id, 
        campaign.campaign_name, 
        report.currency,
        campaign.campaign_status,
        campaign.start_at,
        campaign.end_at,
        sum(report.taps) as taps,
        sum(report.new_downloads) as new_downloads,
        sum(report.redownloads) as redownloads,
        sum(report.new_downloads + report.redownloads) as total_downloads,
        sum(report.conversions) as conversions,
        sum(report.impressions) as impressions,
        sum(report.spend) as spend

        {{ apple_search_ads_persist_pass_through_columns(
            pass_through_variable = 'apple_search_ads__campaign_passthrough_metrics',
            identifier = 'report',
            transform = 'sum',
            coalesce_with = 0,
            exclude_fields = ['conversions']) }}

    from report
    left join campaign 
        on report.campaign_id = campaign.campaign_id
        and report.source_relation = campaign.source_relation
    left join organization 
        on campaign.organization_id = organization.organization_id
        and campaign.source_relation = organization.source_relation
    {{ dbt_utils.group_by(10) }}
)

select * 
from joined